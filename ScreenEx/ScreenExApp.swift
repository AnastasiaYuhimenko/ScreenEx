//
//  ScreenExApp.swift
//  ScreenEx
//
//  Created by Anastasia on 04.04.2026.
//

import SwiftUI
import CoreData

@main
struct ScreenExApp: App {
	
	@StateObject private var viewModel: BaseViewModel = BaseViewModel()
	@StateObject private var searchViewModel: SearchViewModel = SearchViewModel(searchText: "")
	@StateObject private var portfolioModelView: PortfolioModelView = PortfolioModelView()
	@StateObject private var coinManager: AddCoinsToPortfolioViewModel = AddCoinsToPortfolioViewModel()
	let persistenceController: PersistenceController = PersistenceController.shared
	
    var body: some Scene {
        WindowGroup {
			MainScreen()
			.environmentObject(viewModel)
			.environmentObject(searchViewModel)
			.environmentObject(portfolioModelView)
			.environmentObject(coinManager)
			.environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
		
    }
}
