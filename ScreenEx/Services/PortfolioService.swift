//
//  PortfolioService.swift
//  ScreenEx
//
//  Created by Anastasia on 15.04.2026.
//

import Foundation
import Combine

enum PortfolioCoinState {
	case loading
	case success(ExchangeModel)
	case failed(message: String)
}

struct PortfolioCoinItem: Identifiable {
	let id: String
	var state: PortfolioCoinState

	var coin: ExchangeModel? {
		guard case let .success(coin) = state else { return nil }
		return coin
	}

	var errorMessage: String? {
		guard case let .failed(message) = state else { return nil }
		return message
	}
}

class PortfolioService {
	
	@Published var portfolioCoins: [ExchangeModel] = []
	@Published var portfolioItems: [PortfolioCoinItem] = []
	@Published var isLoading: Bool = false
	@Published var error: Error?
	
	private let apiClient: APIClient
	/// Cancels the previous in-flight fetch so overlapping refreshes cannot append the same coins twice.
	private var fetchTask: Task<Void, Never>?
	
	init(apiClient: APIClient = .init()) {
		self.apiClient = apiClient
	}
	
	func fetchCoins(coinsID: [String]) {
		fetchTask?.cancel()
		let orderedUniqueIDs = Self.uniquePreservingOrder(coinsID)
		fetchTask = Task {
			await MainActor.run {
				isLoading = true
				error = nil
				portfolioCoins = []
				portfolioItems = orderedUniqueIDs.map {
					PortfolioCoinItem(id: $0, state: .loading)
				}
			}
			print("[PortfolioService] Starting API request...")
			for elementId in orderedUniqueIDs {
				if Task.isCancelled { break }
				let resource = Resource<[ExchangeModel], CoinRequest>(
					request: CoinRequest(elementId: elementId)
				)
				do {
					let response = try await apiClient.dataTask(with: resource)
					guard let coin = response.first else {
						throw NSError(
							domain: "com.AnastasiaYukhimenko.ScreenEx.Portfolio",
							code: 0,
							userInfo: [NSLocalizedDescriptionKey: "Empty response for id \(elementId)"]
						)
					}
					print("[PortfolioService] Recived \(coin.name ?? "Nill")")
					
					await MainActor.run {
						guard !Task.isCancelled else { return }
						portfolioCoins.append(coin)
						updateItemState(for: elementId, state: .success(coin))
					}
				} catch {
					guard !Task.isCancelled else { break }
					await MainActor.run {
						if self.error == nil {
							self.error = error
						}
						updateItemState(for: elementId, state: .failed(message: error.localizedDescription))
					}
					
					print("[PortfolioService] ERROR \(error.localizedDescription)")

				}
			}
			await MainActor.run {
				guard !Task.isCancelled else { return }
				isLoading = false
			}
		}
		
	}

	private static func uniquePreservingOrder(_ ids: [String]) -> [String] {
		var seen = Set<String>()
		return ids.filter { seen.insert($0).inserted }
	}

	@MainActor
	private func updateItemState(for id: String, state: PortfolioCoinState) {
		guard let index = portfolioItems.firstIndex(where: { $0.id == id }) else { return }
		portfolioItems[index].state = state
	}
}

private struct CoinRequest: Requestable {
	var path: String { "coins/markets" }
	
	var elementId: String

	var parameters: [URLQueryItem] {
		[
			URLQueryItem(name: "vs_currency", value: "usd"),
			URLQueryItem(name: "ids", value: elementId),
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
