package com.techelevator.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class StockData {
	
	private int symbols_requested;
	private Data[] data;
	
	public StockData() {
		
	}

	public int getSymbols_requested() {
		return symbols_requested;
	}

	public Data[] getData() {
		return data;
	}

	public void setData(Data[] data) {
		this.data = data;
	}

	public void setSymbols_requested(int symbols_requested) {
		this.symbols_requested = symbols_requested;
	}

	@Override
	public String toString() {
		return "StockData [symbols_requested=" + symbols_requested + ", data=" + data + "]";
	}

	
	
}
