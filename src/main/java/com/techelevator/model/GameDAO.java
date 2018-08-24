package com.techelevator.model;

import java.util.List;
import java.util.Map;

public interface GameDAO {
	
	public List<UserGame> getGamesByUser(String email);
	
	public Map<Stock, Integer> getTransactionsByUserGame(int portfolioId);
	
	
}
