//
//  ExchangeModel.swift
//  ScreenEx
//
//  Created by Anastasia on 04.04.2026.
//

import Foundation


struct ExchangeModel: Identifiable, Codable {
	let id, symbol, name: String?
	let image: String?
	let currentPrice, marketCap, marketCapRank, fullyDilutedValuation: Double?
	let totalvolume, high24H, Low24H: Int?
	let priceChange24M, priceChangePercentage24H, marketCapChange24H, marketCapChangePercentage24H: Double?
	let circulatingSupply, totalSupply, maxsupply, ath: Int?
	let athChangePercentage: Double?
	let athDate: String?
	let atl, atlChangePercentage: Double?
	let atlDate: String?
	let lastupdated: String?
	let sparklineIn7D: SparklineIn7D?
	let currentHoldings: Double?
	
	enum Codingkeys: String, CodingKey {
		
		case Id, symbol, name, image
		case currentPrice = "current_price"
		case marketCap = "market_cap"
		case marketCapRank = "market"
		case fullyDilutedValuation = "fully diluted valuation"
		case totalVolume = "totalvolume"
		case high24H = "nigh 24h"
		case Low24H = "Low 24h"
		case priceChange24H = "price_change_24h"
		case priceChangePercentage24H = "price change_percentage_24h"
		case marketCapChange24H = "market_cap_change_24h"
		case marketCapChangePercentage24H = "'market_cap_change_percentage_24h"
		case circulatingsupply = "circulating_supply"
		case totalSupply = "total_supply"
		case maxSupply = "max_supply"
		case ath
		case athChangePercentage = "ath_change_percentage"
		case athDate = "ath_date"
		case atl
		case atlChangePercentage = "atlchange_percentage"
		case atlDate = "atl_date"
		case lastUpdated = "'Last_updated"
		case sparklineIn7D = "sparkline_in_7d"
		case currentHoldings
	}
	
	func updateHoldings(amount: Double) -> ExchangeModel {
		return ExchangeModel(id: id, symbol: symbol, name: name, image: image, currentPrice: currentPrice ?? 0, marketCap: marketCap, marketCapRank: marketCapRank, fullyDilutedValuation: fullyDilutedValuation, totalvolume: totalvolume, high24H: high24H, Low24H: Low24H, priceChange24M: priceChange24M, priceChangePercentage24H: priceChangePercentage24H, marketCapChange24H: marketCapChange24H, marketCapChangePercentage24H: marketCapChangePercentage24H, circulatingSupply: circulatingSupply, totalSupply: totalSupply, maxsupply: maxsupply, ath: ath, athChangePercentage: athChangePercentage, athDate: athDate, atl: atl, atlChangePercentage: atlChangePercentage, atlDate: atlDate, lastupdated: lastupdated, sparklineIn7D: sparklineIn7D, currentHoldings: amount)
	}
	
	var currentHoldingsValue: Double {
		return (currentHoldings ?? 0) * (currentPrice ?? 0)
	}
	
	var rank: Int {
		return Int(marketCap ?? 0)
	}
}

struct SparklineIn7D: Codable {
	let price: [Double]?
}
