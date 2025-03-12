 /**
   *  Author: Maxime Lavail
   *  Create Time: 2025-03-10 14:30:06
   *  Modified time: 2025-03-12 15:53:11
 **/

// binance_ws.cpp

#include <boost/beast.hpp>
#include <boost/beast/core.hpp>
#include <boost/beast/websocket.hpp>
#include <boost/beast/ssl.hpp>
#include <boost/asio.hpp>
#include <boost/asio/ssl.hpp>
#include <boost/asio/connect.hpp>
#include <iostream>

#include "binance_data.hpp"

using json = nlohmann::json;
namespace beast = boost::beast;
namespace websocket = beast::websocket;
namespace net = boost::asio;
namespace ssl = net::ssl;
namespace http = beast::http;
using tcp = net::ip::tcp;

void	binance_ws() {

	try {
		net::io_context ioc;
		ssl::context ctx(ssl::context::sslv23_client);

		tcp::resolver resolver(ioc);
		beast::ssl_stream<tcp::socket> ssl_stream(ioc, ctx);
		websocket::stream<beast::ssl_stream<tcp::socket>> ws(std::move(ssl_stream));

		auto const results = resolver.resolve("stream.binance.com", "443");

		net::connect(ws.next_layer().next_layer(), results.begin(), results.end());

		ws.next_layer().handshake(ssl::stream_base::client);

		ws.handshake("stream.binance.com", "/stream?streams=btcusdt@depth5/opbtc@depth5/opusdt@depth5/ethusdt@depth5/injeth@depth5/injusdt@depth5/bnbusdt@depth5/suibnb@depth5/suiusdt@depth5");

		std::cout << "🔗 Connexion WebSocket établie avec Binance." << std::endl;

		beast::flat_buffer buffer;

		while (true) {
			try {
				ws.read(buffer);
				std::string message = beast::buffers_to_string(buffer.data());
				buffer.consume(buffer.size());

				json j = json::parse(message);

				if (j.contains("stream") && j.contains("data")) { 

					std::string stream_name = j["stream"];
					std::string symbol = stream_name.substr(0, stream_name.find('@'));

					if (j["data"].contains("bids") && j["data"]["bids"].is_array() && 
						j["data"].contains("asks") && j["data"]["asks"].is_array() &&
						!j["data"]["bids"].empty() && !j["data"]["asks"].empty()) {

						std::vector<OrderEntry> bids, asks;

						if (!j["data"]["bids"].empty()) {
							bids.emplace_back(std::stod(j["data"]["bids"][0][0].get<std::string>()), 
									std::stod(j["data"]["bids"][0][1].get<std::string>()));
						}

						if (!j["data"]["asks"].empty()) {
							asks.emplace_back(std::stod(j["data"]["asks"][0][0].get<std::string>()), 
									std::stod(j["data"]["asks"][0][1].get<std::string>()));
						}

						BinanceOrdersBooks update(j["data"]["lastUpdateId"], symbol, std::move(bids), std::move(asks));

						/*
						std::cout << "📊 Mise à jour du carnet d'ordres :" << update.Symbol << std::endl;
						
						for (const auto& ask : update.Asks)
							std::cout << "  🔺 Ask: " << ask.Price << " USDT → " << ask.Volume << " " << symbol << std::endl;
						for (const auto& bid : update.Bids)
							std::cout << "  🔻 Bid: " << bid.Price << " USDT → " << bid.Volume << " " << symbol << std::endl;
						*/
					} else {
						std::cerr << "⚠️ Données bids/asks manquantes ou incorrectes pour " << symbol << std::endl;
					}
				}
			} catch (const std::exception& e) {
				std::cerr << "❌ Erreur JSON : " << e.what() << std::endl;
				buffer.consume(buffer.size()); // 🔹 On vide le buffer en cas d'erreur
			}
		}
	} catch (const std::exception& e) {
		std::cerr << "❌ Erreur : " << e.what() << std::endl;
	}
}