package com.techelevator.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;
import org.springframework.stereotype.Component;

@Component
public class JDBCGameDAO implements GameDAO {
	
	private JdbcTemplate jdbcTemplate;
	
	private static final long startingMoney = 10000000;
	
	@Autowired
	public JDBCGameDAO(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}
	

	@Override
	public List<UserGame> getGamesByUser(String email) {
		List<UserGame> myGames = new ArrayList<UserGame>();
		String sqlUserGame = "SELECT games.name, games.start_date, games.end_date, user_game.wallet_value, user_game.portfolio_id "
				+ "FROM games JOIN user_game ON user_game.game_id = games.game_id "
				+ "WHERE user_game.user_email = ?;";
		SqlRowSet results = jdbcTemplate.queryForRowSet(sqlUserGame, email);
		while(results.next()) {
			myGames.add(mapRowToUserGame(results));
		}
		return myGames;
	}

	@Override
	public Map<Stock, Integer> getTransactionsByUserGame(int portfolioId) {
		Map<Stock, Integer> transactions = new HashMap<Stock, Integer>();
		String sqlTransactions = "select * from transactions where portfolio_id = ?"; 
		SqlRowSet results = jdbcTemplate.queryForRowSet(sqlTransactions, portfolioId);
		while(results.next()) {
			transactions.put(mapRowToStock(results), results.getInt("portfolio_id"));
		}
		return null;
	}
	
	private UserGame mapRowToUserGame(SqlRowSet results) {
		UserGame game = new UserGame();
		game.setPortfolioId(results.getInt("portfolio_id"));
		game.setName(results.getString("name"));
		game.setStartDate(results.getDate("start_date"));
		game.setEndDate(results.getDate("end_date"));
		game.setWalletValue(results.getFloat("wallet_value"));
		return game;
	}
	
	private Stock mapRowToStock(SqlRowSet results) {
		Stock myStock = new Stock();
		myStock.setTickerSymbol(results.getString("ticker_symbol"));
		myStock.setCompany(results.getString("company"));
		myStock.setPuchasePrice(results.getLong("price"));
		myStock.setPurchaseDate(results.getTimestamp("date_time"));
		return myStock;
	}


	@Override
	public int createNewGame(String name, Date startDate, Date endDate, String admin) {
		int gameId;
		String sqlInsertGame = "insert into games (name, start_date, end_date, admin) "
				+ "values (?, ?, ?, ?) returning game_id;";
		Integer number = jdbcTemplate.queryForObject(sqlInsertGame, Integer.class, name, startDate, endDate, admin);
		gameId = number.intValue();
		return gameId;
	}


	@Override
	public void addPlayers(int gameId, String email) {
		String SqlInsertUserGame = "insert into user_game (game_id, user_email, wallet_value) "
				+ "values (?, ?, ?);";
		jdbcTemplate.update(SqlInsertUserGame, gameId, email, startingMoney);
	}


	@Override
	public void addInvitedPlayers(int gameId, String email) {
		String sqlAddInvitedPlayers = "insert into invited_players (game_id, email) "
				+ "values (?, ?);";
		jdbcTemplate.update(sqlAddInvitedPlayers);
	}


	@Override
	public void deleteInvitedPlayers(String email) {
		String sqlDeleteTempGames = "delete from invited_players where email = ?";
		jdbcTemplate.update(sqlDeleteTempGames, email);
	}


	@Override
	public List<TempGame> getInvitedGamesByPlayer(String email) {
		List<TempGame> tempGames = new ArrayList<TempGame>();
		String sqlGetTempGames = "select * from invited_players where email = ?";
		SqlRowSet results = jdbcTemplate.queryForRowSet(sqlGetTempGames, email);
		while(results.next()) {
			TempGame game = new TempGame();
			game.setEmail(results.getString("email"));
			game.setGameId(results.getInt("game_id"));
			tempGames.add(game);
		}
		return tempGames;
	}
	
	

}