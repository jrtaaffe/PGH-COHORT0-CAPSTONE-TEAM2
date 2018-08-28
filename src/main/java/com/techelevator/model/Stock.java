package com.techelevator.model;


import java.sql.Timestamp;


public class Stock {
	
	private String tickerSymbol;
	
	private String company;
	
	private long puchasePrice;
	
	private Timestamp purchaseDate;

	public String getTickerSymbol() {
		return tickerSymbol;
	}

	public void setTickerSymbol(String tickerSymbol) {
		this.tickerSymbol = tickerSymbol;
	}

	public String getCompany() {
		return company;
	}

	public void setCompany(String company) {
		this.company = company;
	}

	public long getPuchasePrice() {
		return puchasePrice;
	}

	public void setPuchasePrice(long puchasePrice) {
		this.puchasePrice = puchasePrice;
	}

	public Timestamp getPurchaseDate() {
		return purchaseDate;
	}

	public void setPurchaseDate(Timestamp purchaseDate) {
		this.purchaseDate = purchaseDate;
	}
	
	
}
