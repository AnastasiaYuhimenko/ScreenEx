//
//  SearchViewModel.swift
//  ScreenEx
//
//  Created by Anastasia on 09.04.2026.
//

import Foundation
import Combine
import SwiftUI

enum searchPlaceEnum {
	case portfolio
	case allCoins
}
class SearchViewModel: ObservableObject {
	
	@Published var searchText: String
	
	init(searchText: String) {
		self.searchText = searchText
	}
}

// MARK: - For portfolio
extension SearchViewModel {
	
	func filteredCoinsPortfolio(from coins: [ExchangeModel]) -> [ExchangeModel] {
		if searchText.isEmpty {
			return coins
		}

		return coins.filter {
			($0.name ?? "").localizedCaseInsensitiveContains(searchText)
		}
	}
}

// MARK: - for all coins
extension SearchViewModel {
	
	// TODO: - написать сетевой запрос
	
}
