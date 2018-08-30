package com.techelevator.model;

import java.util.Date;

public class UserGame {
	
	private int portfolioId;
	
	private int gameId;
	
	private String name;

	private String status;


	private Date startDate;
	
	private Date endDate;
	
	private float walletValue;

	public String getStatus() {
		return status;
	}

	public int getPortfolioId() {
		return portfolioId;
	}

	public void setPortfolioId(int portfolioId) {
		this.portfolioId = portfolioId;
	}
	
	public int getGameId() {
		return gameId;
	}
	
	public void setGameId(int gameId) {
		this.gameId = gameId;
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

	public float getWalletValue() {
		return walletValue;
	}

	public void setWalletValue(float walletValue) {
		this.walletValue = walletValue;
	}

	public void setStatus(String status) {
		// TODO Auto-generated method stub
		this.status = status;
	}
	
	
}
