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
	@Published var isLoading: Bool = false
	@Published var loadError: Error?

	private let dataService: MarketDataService = MarketDataService()
	var cancellabels = Set<AnyCancellable>()

	init() {
		withAnimation(.easeInOut) {
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
}
