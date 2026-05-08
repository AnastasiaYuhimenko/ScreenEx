//
//  CoinService.swift
//  ScreenEx
//
//  Created by Anastasia on 26.04.2026.
//

import Foundation
import Combine

class Coinservice {
	
	@Published var loadError: Error?
	@Published var isLoading: Bool = false
	
	private let apiClient: APIClient
	
	init(apiClient: APIClient = .init()) {
		self.apiClient = apiClient
	}
	
	func fetch(coinID: String) async -> ExchangeModel? {
		
		await MainActor.run {
			self.isLoading = true
		}
		
		let resourse = Resource<[ExchangeModel], CoinRequest>(
			request: CoinRequest(elementId: coinID)
		)
		
		do {
			let responce = try await apiClient.dataTask(with: resourse)
			guard let coin = responce.first else {
				throw NSError(
					domain: "com.AnastasiaYukhimenko.ScreenEx.Portfolio", code: 0,
					userInfo: [NSLocalizedDescriptionKey: "Empty responcse for coin \(coinID)"]
					)
			}
			print("[ Coinservice ] recived \(String(describing: coin.name ?? nil))")
			return coin
		} catch {
			await MainActor.run {
				if self.loadError == nil {
					self.loadError = error
					print("[ Coinservice ] error \(error.localizedDescription)")
				}
			}
		}
		
		await MainActor.run {
			self.isLoading = false
		}
		return nil
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
