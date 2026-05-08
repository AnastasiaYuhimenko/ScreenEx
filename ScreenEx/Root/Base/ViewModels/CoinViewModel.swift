//
//  CoinViewModel.swift
//  ScreenEx
//
//  Created by Anastasia on 26.04.2026.
//

import Foundation
import Combine

class CoinViewModel: ObservableObject {
	@Published var info: ExchangeModel? = nil
	let id: String
	
	init(id: String) {
		self.id = id
	}
	
	func getInfo() {
		
	}
}
