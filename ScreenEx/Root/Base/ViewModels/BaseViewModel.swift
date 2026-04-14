//
//  BaseViewModel.swift
//  ScreenEx
//
//  Created by Anastasia on 09.04.2026.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class BaseViewModel: ObservableObject {
	@Published var exchangeCoins: [ExchangeModel] = []
	@Published var portfolioCoins: [ExchangeModel] = []
	@Published var isLoading: Bool = false
	@Published var loadError: Error?

	private let dataService: MarketDataService = MarketDataService()
	var cancellabels = Set<AnyCancellable>()

	init() {
		withAnimation(.easeInOut) {
			self.portfolioCoins.append(CoinPreviewModel.shared.coin)
			self.portfolioCoins.append(CoinPreviewModel.shared.coin)
			addSubscribers()
		}
	}
	
	func addSubscribers() {
		dataService.$exchangeCoins
			.sink { [weak self] returnedCoins in
				self?.exchangeCoins = returnedCoins
			}
			.store(in: &cancellabels)

		dataService.$isLoading
			.assign(to: &$isLoading)

		dataService.$error
			.assign(to: &$loadError)
	}

	func refresh() {
		dataService.fetchMarketData()
	}
	
	func deletePortfolioCoins(at offsets: IndexSet) {
		let safeOffsets = IndexSet(offsets.filter { $0 < portfolioCoins.count })
		guard !safeOffsets.isEmpty else { return }
		
		withAnimation(.easeInOut) {
			portfolioCoins.remove(atOffsets: safeOffsets)
		}
	}
	
	func deletePortfolioCoins(withIds ids: [String]) {
		let idSet = Set(ids)
		guard !idSet.isEmpty else { return }
		withAnimation(.easeInOut) {
			portfolioCoins.removeAll { coin in
				guard let id = coin.id else { return false }
				return idSet.contains(id)
			}
		}
	}

	
}
