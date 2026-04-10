//
//  ExchangeModel.swift
//  ScreenEx
//
//  Created by Anastasia on 04.04.2026.
//

import Foundation


struct ExchangeModel: Identifiable, Codable, Equatable {
	let id, symbol, name: String?
	let image: String?
	let currentPrice, marketCap, marketCapRank, fullyDilutedValuation: Double?
	let totalVolume, high24H, low24H: Int?
	let priceChange24H, priceChangePercentage24H, marketCapChange24H, marketCapChangePercentage24H: Double?
	let circulatingSupply, totalSupply, maxSupply, ath: Int?
	let athChangePercentage: Double?
	let athDate: String?
	let atl, atlChangePercentage: Double?
	let atlDate: String?
	let lastUpdated: String?
	let sparklineIn7D: SparklineIn7D?
	let currentHoldings: Double?
	
	enum Codingkeys: String, CodingKey {
		
		case Id, symbol, name, image
		case currentPrice = "current_price"
		case marketCap = "market_cap"
		case marketCapRank = "market"
		case fullyDilutedValuation = "fully_diluted_valuation"
		case totalVolume = "total_volume"
		case high24H = "nigh_24h"
		case low24H = "low_24h"
		case priceChange24H = "price_change_24h"
		case priceChangePercentage24H = "price_change_percentage_24h"
		case marketCapChange24H = "market_cap_change_24h"
		case marketCapChangePercentage24H = "'market_cap_change_percentage_24h"
		case circulatingsupply = "circulating_supply"
		case totalSupply = "total_supply"
		case maxSupply = "max_supply"
		case ath
		case athChangePercentage = "ath_change_percentage"
		case athDate = "ath_date"
		case atl
		case atlChangePercentage = "atl_change_percentage"
		case atlDate = "atl_date"
		case lastUpdated = "last_updated"
		case sparklineIn7D = "sparkline_in_7d"
		case currentHoldings
	}
	
	func updateHoldings(amount: Double) -> ExchangeModel {
		return ExchangeModel(id: id, symbol: symbol, name: name, image: image, currentPrice: currentPrice ?? 0, marketCap: marketCap, marketCapRank: marketCapRank, fullyDilutedValuation: fullyDilutedValuation, totalVolume: totalVolume, high24H: high24H, low24H: low24H, priceChange24H: priceChange24H, priceChangePercentage24H: priceChangePercentage24H, marketCapChange24H: marketCapChange24H, marketCapChangePercentage24H: marketCapChangePercentage24H, circulatingSupply: circulatingSupply, totalSupply: totalSupply, maxSupply: maxSupply, ath: ath, athChangePercentage: athChangePercentage, athDate: athDate, atl: atl, atlChangePercentage: atlChangePercentage, atlDate: atlDate, lastUpdated: lastUpdated, sparklineIn7D: sparklineIn7D, currentHoldings: amount)
	}
	
	var currentHoldingsValue: Double {
		return (currentHoldings ?? 0) * (currentPrice ?? 0)
	}
	
	var rank: Int {
		return Int(marketCap ?? 0)
	}
}

struct SparklineIn7D: Codable, Equatable {
	let price: [Double]?
}
