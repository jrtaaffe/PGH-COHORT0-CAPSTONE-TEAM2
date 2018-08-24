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
}
