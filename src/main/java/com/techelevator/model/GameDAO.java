package com.techelevator.model;

import java.util.Date;
import java.util.List;
import java.util.Map;

public interface GameDAO {
	
	public List<UserGame> getGamesByUser(String email);
	
	public Map<Stock, Integer> getTransactionsByUserGame(int portfolioId);
	
	public int createNewGame(String name, Date startDate, Date endDate, String admin);
	
	public void addPlayers(int gameId, String email);
	
	public void addInvitedPlayers(int gameId, String email);
	
	public void deleteInvitedPlayers(String email);
	
	public List<TempGame> getInvitedGamesByPlayer(String email);
	
	public void buyInitialStock(int portfolioId, String tickerSymbol, String company, int quantity);
	
	public void buyOrSellStock(String tickerSymbol, int quantity, int portfolioId);
	
	public void deleteStock(String tickerSymbol);
	
	public void updateWalletValue(float walletValue, int portfolioId);

	public int getPortfolioId(String email, int gameId);

	public UserGame getGameById(int gameId);
}
