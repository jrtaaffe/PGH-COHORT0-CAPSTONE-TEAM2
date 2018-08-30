package com.techelevator.model;

import java.sql.Timestamp;
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
public class JDBCGameDAO implements GameDAO  {
	
	private JdbcTemplate jdbcTemplate;
	
	private static final long startingMoney = 10000000;
	
	private static String status = "active";
	
	@Autowired
	public JDBCGameDAO(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}
	

	@Override
	public List<UserGame> getGamesByUser(String email) {
		List<UserGame> myGames = new ArrayList<UserGame>();
		String sqlUserGame = "SELECT games.game_id, games.name, games.start_date, games.end_date, user_game.wallet_value, user_game.portfolio_id "
				+ "FROM games JOIN user_game ON user_game.game_id = games.game_id "
				+ "WHERE user_game.user_email = ?;";
		SqlRowSet results = jdbcTemplate.queryForRowSet(sqlUserGame, email);
		while(results.next()) {
			myGames.add(mapRowToUserGame(results));
		}
		return myGames;
	}
	
	@Override
	public List<UserGame> getAllActiveGames() {
		List<UserGame> allActiveGames = new ArrayList<UserGame>();
		String activeGame = "SELECT * FROM games";
		SqlRowSet results = jdbcTemplate.queryForRowSet(activeGame);
		while(results.next()) {
			allActiveGames.add(mapRowToGame(results));
		}
		
		return allActiveGames;
		
	}
	
	@Override
	public UserGame getGameById(int gameId) {
		UserGame myGame = new UserGame();
		String sqlGame = "SELECT game_id, name, start_date, end_date "
				+ "FROM games "
				+ "WHERE game_id = ?;";
		SqlRowSet results = jdbcTemplate.queryForRowSet(sqlGame, gameId);
		while(results.next()) {
			myGame = mapRowToGame(results);
		}
		return myGame;
	}

	@Override
	public Map<String, Integer> getTransactionsByUserGame(int portfolioId) {
		Map<String, Integer> transactions = new HashMap<String, Integer>();
		String sqlTransactions = "select * from transactions where portfolio_id = ?"; 
		SqlRowSet results = jdbcTemplate.queryForRowSet(sqlTransactions, portfolioId);
		while(results.next()) {
			transactions.put(results.getString("ticker_symbol"), results.getInt("quantity"));
		}
		return transactions;
	}
	
	private UserGame mapRowToUserGame(SqlRowSet results) {
		UserGame game = new UserGame();
		game.setPortfolioId(results.getInt("portfolio_id"));
		game.setGameId(results.getInt("game_id"));
		game.setName(results.getString("name"));
		game.setStartDate(results.getDate("start_date"));
		game.setEndDate(results.getDate("end_date"));
		game.setWalletValue(results.getFloat("wallet_value"));
		return game;
	}
	
	private UserGame mapRowToGame(SqlRowSet results) {
		UserGame game = new UserGame();
		game.setGameId(results.getInt("game_id"));
		game.setName(results.getString("name"));
		game.setStartDate(results.getDate("start_date"));
		game.setEndDate(results.getDate("end_date"));
		return game;
	}
	
	
	private Stock mapRowToStock(SqlRowSet results) {
		Stock myStock = new Stock();
		myStock.setTickerSymbol(results.getString("ticker_symbol"));
		return myStock;
	}


	@Override
	public int createNewGame(String name, Date startDate, Date endDate, String admin) {
		int gameId;
		String sqlInsertGame = "insert into games (name, start_date, end_date, admin, status) "
				+ "values (?, ?, ?, ?, ?) returning game_id;";
		Integer number = jdbcTemplate.queryForObject(sqlInsertGame, Integer.class, name, startDate, endDate, admin, status);
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
		jdbcTemplate.update(sqlAddInvitedPlayers, gameId, email);
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

	@Override
	public void buyInitialStock(int portfolioId, String tickerSymbol, int quantity) {	
		String buy = "INSERT INTO transactions (portfolio_id, ticker_symbol, quantity) "
				+ "VALUES (?, ?, ?);";
		jdbcTemplate.update(buy, portfolioId, tickerSymbol, quantity);
		
	}

	
	public void buyOrSellStock(String tickerSymbol, int quantity, int portfolioId) {
		String buyOrSell = "UPDATE transactions SET quantity = ? WHERE ticker_symbol = ? AND portfolio_id = ?;";		
		jdbcTemplate.update(buyOrSell, quantity, tickerSymbol, portfolioId);
	}
	
	
	@Override		//to prevent stock with 0 quantity from showing up on User's portfolio. Run when stock is sold.
	public void deleteStock(String tickerSymbol, int portfolioId) { 	
		String delete = "DELETE FROM transactions WHERE ticker_symbol = ? AND portfolio_id = ?;";
		jdbcTemplate.update(delete, tickerSymbol, portfolioId);
	}


	@Override
	public void updateWalletValue(float walletValue, int portfolioId) {
		String wallet = "UPDATE user_game SET wallet_value = ? WHERE portfolio_id = ?;";
		jdbcTemplate.update(wallet, walletValue, portfolioId);
	}

	public int getPortfolioId(String email, int gameId) {
		String sqlGetPortfolioId = "select portfolio_id from user_game where user_email = ? and game_id = ?;";
		SqlRowSet results = jdbcTemplate.queryForRowSet(sqlGetPortfolioId, email, gameId);
		if (!results.wasNull()) {
			results.next();
			int portfolioId = results.getInt("portfolio_id");
			return portfolioId;
		}
		
		else {
			return -1;
		}
	}


	@Override
	public float getWalletValueByPortfolio(int portfolioId) {
		String sqlGetWallet = "SELECT wallet_value FROM user_game WHERE portfolio_id = ?;";
		SqlRowSet result = jdbcTemplate.queryForRowSet(sqlGetWallet, portfolioId);

		if(!result.wasNull() && portfolioId != -1) {
			result.next();
			float currentWallet = result.getFloat("wallet_value");
			return currentWallet;
		}
		else {
			return 0;
		}
	}

}
