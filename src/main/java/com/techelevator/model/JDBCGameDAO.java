package com.techelevator.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.rowset.SqlRowSet;

public class JDBCGameDAO implements GameDAO {
	
	private JdbcTemplate jdbcTemplate;
	
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
		game.setWalletValue(results.getLong("wallet_id"));
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

}
