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
	
	init() {
		withAnimation(.easeInOut) {
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				self.exchangeCoins.append(CoinPreviewModel.shared.coin)
				self.exchangeCoins.append(CoinPreviewModel.shared.coin)
				self.exchangeCoins.append(CoinPreviewModel.shared.coin)
				self.portfolioCoins.append(CoinPreviewModel.shared.coin)
				self.portfolioCoins.append(CoinPreviewModel.shared.coin)
				self.portfolioCoins.append(CoinPreviewModel.shared.coin)
			}
			
		}
	}
	
	func deletePortfolioCoins(at offsets: IndexSet) {
		let safeOffsets = IndexSet(offsets.filter { $0 < portfolioCoins.count })
		guard !safeOffsets.isEmpty else { return }
		
		withAnimation(.easeInOut) {
			portfolioCoins.remove(atOffsets: safeOffsets)
		}
	}
	
	/// Удаление по id (нужно при удалении из отфильтрованного списка).
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
