//
//  SearchService.swift
//  ScreenEx
//
//  Created by Anastasia on 15.04.2026.
//

import Foundation
import Combine

class SearchService {
//	@Published var searchQuery: String = ""
	@Published var searchResult: [ExchangeModel] = []
	@Published var isLoading: Bool = false
	@Published var loadError: Error?
	private let apiClient: APIClient
	private var searchTask: Task<Void, Never>?
	
	init(apiClient: APIClient = .init()) {
		self.apiClient = apiClient
		
	}
	
	func searchCoins(searchQuery: String) {
		searchTask?.cancel()
		searchTask = Task {
			await MainActor.run {
				isLoading = true
				loadError = nil
				searchResult = []
			}
			
			print("[SearchService] Starting API request...")
			
			do {
				let response = try await apiClient.dataTask(with: Resource<SearchResponse, SearchRequest>(
						request: SearchRequest(query: searchQuery)
					)
				)
				let ids = Array(response.coins.compactMap(\.id).prefix(25))
				var marketByID: [String: ExchangeModel] = [:]
				do {
					let marketCoins = try await fetchMarketsForSearch(ids: ids)
					marketByID = Dictionary(
						uniqueKeysWithValues: marketCoins.compactMap { coin in
							guard let id = coin.id else { return nil }
							return (id, coin)
						}
					)
				} catch {
					print("[SearchService] Markets enrichment skipped: \(error.localizedDescription)")
				}
				
				let coins = response.coins.map { searchCoin in
					let marketCoin = searchCoin.id.flatMap { marketByID[$0] }
					return merge(searchCoin: searchCoin, with: marketCoin)
				}
				
				print("📊 [SearchService] ✅ Received \(coins.count) coins")
				
				await MainActor.run {
					searchResult = coins
					isLoading = false
					loadError = nil
				}
			} catch {
				if Task.isCancelled { return }
				await MainActor.run {
					self.loadError = error
					isLoading = false
				}
				print("[SearchService] ERROR \(error.localizedDescription)")
			}
			
			
		}
	}

	private func fetchMarketsForSearch(ids: [String]) async throws -> [ExchangeModel] {
		guard !ids.isEmpty else { return [] }
		let resource = Resource<[ExchangeModel], SearchMarketsRequest>(
			request: SearchMarketsRequest(ids: ids.joined(separator: ","))
		)
		return try await apiClient.dataTask(with: resource)
	}

	private func merge(searchCoin: SearchCoin, with marketCoin: ExchangeModel?) -> ExchangeModel {
		ExchangeModel(
			id: searchCoin.id ?? marketCoin?.id,
			symbol: searchCoin.symbol ?? marketCoin?.symbol,
			name: searchCoin.name ?? marketCoin?.name,
			image: searchCoin.large ?? searchCoin.thumb ?? marketCoin?.image,
			currentPrice: marketCoin?.currentPrice,
			marketCap: marketCoin?.marketCap,
			marketCapRank: marketCoin?.marketCapRank,
			fullyDilutedValuation: marketCoin?.fullyDilutedValuation,
			totalVolume: marketCoin?.totalVolume,
			high24H: marketCoin?.high24H,
			low24H: marketCoin?.low24H,
			priceChange24H: marketCoin?.priceChange24H,
			priceChangePercentage24H: marketCoin?.priceChangePercentage24H,
			marketCapChange24H: marketCoin?.marketCapChange24H,
			marketCapChangePercentage24H: marketCoin?.marketCapChangePercentage24H,
			circulatingSupply: marketCoin?.circulatingSupply,
			totalSupply: marketCoin?.totalSupply,
			maxSupply: marketCoin?.maxSupply,
			ath: marketCoin?.ath,
			athChangePercentage: marketCoin?.athChangePercentage,
			athDate: marketCoin?.athDate,
			atl: marketCoin?.atl,
			atlChangePercentage: marketCoin?.atlChangePercentage,
			atlDate: marketCoin?.atlDate,
			lastUpdated: marketCoin?.lastUpdated,
			sparklineIn7D: marketCoin?.sparklineIn7D,
			currentHoldings: nil
		)
	}
}

private struct SearchResponse: Decodable {
	let coins: [SearchCoin]
}

private struct SearchCoin: Decodable {
	let id: String?
	let symbol: String?
	let name: String?
	let thumb: String?
	let large: String?
}

private struct SearchRequest: Requestable {
	var path: String { "search" }
	var query: String
	var parameters: [URLQueryItem] {
		[
			URLQueryItem(name: "query", value: query)
		]
	}
	
	var headers: [HTTPHeaderKey: String] {
		[
			.accept: AppConstants.HTTP.jsonMediaType,
			.coinGeckoDemoAPIKey: AppConstants.CoinGecko.demoAPIKey
		]
	}
	
	var timeoutInterval: TimeInterval? { 10 }
}

private struct SearchMarketsRequest: Requestable {
	let ids: String
	var path: String { "coins/markets" }

	var parameters: [URLQueryItem] {
		[
			URLQueryItem(name: "vs_currency", value: "usd"),
			URLQueryItem(name: "ids", value: ids),
			URLQueryItem(name: "sparkline", value: "false"),
			URLQueryItem(name: "price_change_percentage", value: "24")
		]
	}

	var headers: [HTTPHeaderKey: String] {
		[
			.accept: AppConstants.HTTP.jsonMediaType,
			.coinGeckoDemoAPIKey: AppConstants.CoinGecko.demoAPIKey
		]
	}

	var timeoutInterval: TimeInterval? { 10 }
}


private extension HTTPHeaderKey {
	static let coinGeckoDemoAPIKey = HTTPHeaderKey("x-cg-demo-api-key")
}
