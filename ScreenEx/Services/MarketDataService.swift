//
//  MarketDataService.swift
//  ScreenEx
//
//  Created by Anastasia on 10.04.2026.
//

import Combine
import Foundation

class MarketDataService {

	@Published var exchangeCoins: [ExchangeModel] = []
	@Published var isLoading: Bool = false
	@Published var error: Error?

	private let apiClient: APIClient
	private var retryTask: Task<Void, Never>?
	private let backgroundRetryDelay: TimeInterval = 15.0

	init(apiClient: APIClient = .init()) {
		self.apiClient = apiClient
		fetchMarketData()
	}

	func fetchMarketData() {
		print("📊 [MarketDataService] fetchMarketData() called")
		retryTask?.cancel()
		retryTask = nil

		let resource = Resource<[ExchangeModel], CoinGeckoMarketsRequest>(
			request: CoinGeckoMarketsRequest()
		)

		Task {
			await MainActor.run {
				isLoading = true
				error = nil
			}
			print("📊 [MarketDataService] Starting API request...")

			do {
				let coins = try await apiClient.dataTask(with: resource)
				print("📊 [MarketDataService] ✅ Received \(coins.count) coins")
				await MainActor.run {
					exchangeCoins = coins
					isLoading = false
					error = nil
				}
			} catch {
				await MainActor.run {
					self.error = error
					isLoading = false
				}
				print("📊 [MarketDataService] ❌ Error: \(error.localizedDescription)")
				print("📊 [MarketDataService] Scheduling background retry in \(backgroundRetryDelay)s...")
				scheduleBackgroundRetry()
			}
		}
	}

	private func scheduleBackgroundRetry() {
		retryTask?.cancel()
		retryTask = Task {
			do {
				try await Task.sleep(nanoseconds: UInt64(backgroundRetryDelay * 1_000_000_000))
				if !Task.isCancelled {
					print("📊 [MarketDataService] 🔄 Background retry triggered")
					fetchMarketData()
				}
			} catch {
				print("📊 [MarketDataService] Background retry cancelled")
			}
		}
	}
}

// MARK: - CoinGecko

private struct CoinGeckoMarketsRequest: Requestable {
	var path: String { "coins/markets" }

	var parameters: [URLQueryItem] {
		[
			URLQueryItem(name: "vs_currency", value: "usd"),
			URLQueryItem(name: "order", value: "market_cap_desc"),
			URLQueryItem(name: "per_page", value: "250"),
			URLQueryItem(name: "page", value: "1"),
			URLQueryItem(name: "sparkline", value: "true"),
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
