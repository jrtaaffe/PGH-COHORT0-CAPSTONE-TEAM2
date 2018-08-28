package com.techelevator.model;

import java.sql.Timestamp;

public class Transaction {
	
	private String tickerSymbol;
	private int portfolioId;
	private String company;
	private int quantity;
	
	
	public void setPortfolioId(int portfolioId) {
		this.portfolioId = portfolioId;
	}
	public void setCompany(String company) {
		this.company = company;
	}
	public void setTickerSymbol(String tickerSymbol) {
		this.tickerSymbol = tickerSymbol;
	}
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	public String getTickerSymbol() {
		return tickerSymbol;
	}
	public int getPortfolioId() {
		return portfolioId;
	}
	public String getCompany() {
		return company;
	}

	public int getQuantity() {
		return quantity;
	}

	


}
