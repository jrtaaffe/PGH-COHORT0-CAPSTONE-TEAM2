package com.techelevator.model;

import java.util.Date;

public class UserGame {
	
	private int portfolioId;
	
	private String name;
	
	private Date startDate;
	
	private Date endDate;
	
	private long walletValue;

	public int getPortfolioId() {
		return portfolioId;
	}

	public void setPortfolioId(int portfolioId) {
		this.portfolioId = portfolioId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Date getStartDate() {
		return startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	public long getWalletValue() {
		return walletValue;
	}

	public void setWalletValue(long walletValue) {
		this.walletValue = walletValue;
	}
	
	
}
