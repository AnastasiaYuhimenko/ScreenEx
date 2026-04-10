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
	
    var body: some Scene {
        WindowGroup {
			NavigationView {
				MainScreen()
			}
			.environmentObject(viewModel)
			.environmentObject(searchViewModel)
        }
		
    }
}
