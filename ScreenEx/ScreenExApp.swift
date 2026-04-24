//
//  ScreenExApp.swift
//  ScreenEx
//
//  Created by Anastasia on 04.04.2026.
//

import SwiftUI

@main
struct ScreenExApp: App {
	
	@StateObject private var viewModel: BaseViewModel = BaseViewModel()
	@StateObject private var searchViewModel: SearchViewModel = SearchViewModel(searchText: "")
	@StateObject private var portfolioModelView: PortfolioModelView = PortfolioModelView()
	@StateObject private var coinManager: AddCoinsToPortfolioViewModel = AddCoinsToPortfolioViewModel()
	
    var body: some Scene {
        WindowGroup {
			MainScreen()
			.environmentObject(viewModel)
			.environmentObject(searchViewModel)
			.environmentObject(portfolioModelView)
			.environmentObject(coinManager)
        }
		
    }
}
