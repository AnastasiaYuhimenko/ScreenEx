//
//  AddCoinsToPortfolioViewModel.swift
//  ScreenEx
//
//  Created by Anastasia on 15.04.2026.
//

import Foundation
import Combine

class AddCoinsToPortfolioViewModel: ObservableObject {
	@Published var CoinsID: [String] = []
	
	func addCoin(id: String) {
		guard !CoinsID.contains(id) else { return }
		CoinsID.append(id)
	}
	
	func deleteCoin(id: String) {
		CoinsID.removeAll(where: { $0 == id })
	}
}
