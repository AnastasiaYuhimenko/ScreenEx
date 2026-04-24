//
//  PortfolioModelView.swift
//  ScreenEx
//
//  Created by Anastasia on 15.04.2026.
//


import Foundation
import Combine
import SwiftUI

@MainActor
class PortfolioModelView: ObservableObject {
	@Published var portfolioCoins: [ExchangeModel] = []
	@Published var isLoading: Bool = false
	@Published var loadError: Error?
	@Published var portfolioItems: [PortfolioCoinItem] = []

	private let dataService: PortfolioService = PortfolioService()
	var cancellabels = Set<AnyCancellable>()

	init() {
		withAnimation(.easeInOut) {
			addSubscribers()
		}
	}
	
	func addSubscribers() {
		dataService.$portfolioCoins
			.sink { [weak self] returnedCoins in
				withAnimation(.easeInOut(duration: 0.35)) {
					self?.portfolioCoins = returnedCoins
				}
			}
			.store(in: &cancellabels)

		dataService.$isLoading
			.sink { [weak self] loading in
				withAnimation(.easeInOut(duration: 0.35)) {
					self?.isLoading = loading
				}
			}
			.store(in: &cancellabels)

		dataService.$error
			.assign(to: &$loadError)
		
		dataService.$portfolioItems
			.assign(to: &$portfolioItems)
	}

	func refresh(coinsID: [(String, Double)]) {
		dataService.fetchCoins(coinsID: coinsID)
	}
//	
//	func deletePortfolioCoins(at offsets: IndexSet) {
//		let safeOffsets = IndexSet(offsets.filter { $0 < portfolioCoins.count })
//		guard !safeOffsets.isEmpty else { return }
//		
//		withAnimation(.easeInOut) {
//			portfolioCoins.remove(atOffsets: safeOffsets)
//		}
//	}
//	
//	func deletePortfolioCoins(withIds ids: [String]) {
//		let idSet = Set(ids)
//		guard !idSet.isEmpty else { return }
//		withAnimation(.easeInOut) {
//			portfolioCoins.removeAll { coin in
//				guard let id = coin.id else { return false }
//				return idSet.contains(id)
//			}
//		}
//	}

	
}
