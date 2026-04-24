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
	
	@Published var searchResult: [ExchangeModel] = []
	@Published var isLoading: Bool = false
	@Published var loadError: Error?
	@Published var searchText: String
	
	private let service: SearchService = SearchService()
	var cancellabels = Set<AnyCancellable>()
	
	init(searchText: String) {
		self.searchText = searchText
		addSubScribers()
		addSearchSubScribers()
	}
	
	func addSubScribers() {
		service.$loadError
			.assign(to: &$loadError)
		
		service.$isLoading
			.assign(to: &$isLoading)
		
		service.$searchResult
			.sink { [ weak self ] searchResult in
				self?.searchResult = searchResult
			}
			.store(in: &cancellabels)
	}
	
	private func addSearchSubScribers() {
		$searchText
			.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }  // remove whitespace and newlines
			.removeDuplicates()  // remove duplicate search queries
			.debounce(for: .milliseconds(400), scheduler: RunLoop.main)  // wait for 400 milliseconds before executing the search
			.sink { [weak self] query in
				guard let self else { return }

				if query.isEmpty {
					self.searchResult = []
					self.isLoading = false
					self.loadError = nil
					return
				}

				self.service.searchCoins(searchQuery: query)
			}
			.store(in: &cancellabels)
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

// MARK: - For all coins
extension SearchViewModel {
	
	func filteredCoinsAll(from coins: [ExchangeModel]) -> [ExchangeModel] {
		if searchText.isEmpty {
			return coins
		}
		
		if !searchResult.isEmpty {
			return searchResult
		}
		
		return coins.filter {
			($0.name ?? "").localizedCaseInsensitiveContains(searchText) ||
			($0.symbol ?? "").localizedCaseInsensitiveContains(searchText)
		}
	}
}