/**
 *  Author: Maxime Lavail
 *  Create Time: 2025-03-12 13:30:14
 *  Modified time: 2025-03-12 15:20:05
 **/

// binance_data.hpp

#pragma once

#include <iostream>
#include <string>
#include <vector>
#include "./json.hpp"

struct OrderEntry {
	double	Price;
	double	Volume;

	OrderEntry(double price, double volume) 
		: Price(price), Volume(volume) {}
};

struct BinanceOrdersBooks {
	long 				TimeStamp;    // Timestamp de la mise à jour
	std::string			Symbol;       // Symbole de la paire (ex: BTCUSDT)
	std::vector<OrderEntry> 	Bids; 		// Liste des bids (prix + volume)
	std::vector<OrderEntry>	Asks; 		// Liste des asks (prix + volume)

	BinanceOrdersBooks(long timestamp, 
				const std::string& symbol,
				std::vector<OrderEntry> bids, 
				std::vector<OrderEntry> asks)
		: TimeStamp(timestamp), Symbol(symbol), 
		Bids(std::move(bids)), Asks(std::move(asks)) {}
};


void binance_ws();