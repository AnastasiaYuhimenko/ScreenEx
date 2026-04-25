//
//  mainScreen.swift
//  ScreenEx
//
//  Created by Anastasia on 09.04.2026.
//

import SwiftUI
import CoreData

struct MainScreen: View {
	
	@State private var selectedTab: Int = 0
	@EnvironmentObject private var viewModel: BaseViewModel
	
	var body: some View {
		ZStack {
			Color.background
				.ignoresSafeArea()
	
				VStack(spacing: 0) {
					TabView(selection: $selectedTab) {
						Portfolio(searchViewModel: SearchViewModel(searchText: ""))
							
							.tag(0)
							.tabItem {
								Label("Portfolio", systemImage: "basket")
							}
						TopCoinsScreen(searchViewModel: SearchViewModel(searchText: ""))
						
							.tag(1)
							.tabItem {
								Label("Top", systemImage: "chart.line.uptrend.xyaxis")
							}
					}
					
					
				
			}
		}
	}
// MARK: - мне не нравится что swipeGesture конфликтует с ondelete в списке, поэтому я решила его убрать, но если вдруг передумаю - вот код
//	func swipeGesture() -> some Gesture {
//		DragGesture(minimumDistance: 50)
//			.onEnded { value in
//				let threshold: CGFloat = 80
//				let screenWidth = UIScreen.currentBounds.width
//				let deleteZone: CGFloat = 80
//				
//				let startX = value.startLocation.x
//				let isFromDeleteZone = startX > screenWidth - deleteZone
//				
//				guard !isFromDeleteZone else { return }
//				
//				let isHorizontalSwipe = abs(value.translation.width) > abs(value.translation.height) * 1.2
//				guard isHorizontalSwipe else { return }
//				
//				if value.translation.width < -threshold && selectedTab < 1 {
//					
//					withAnimation(.easeInOut(duration: 0.25)) {
//						selectedTab += 1
//					}
//				} else if value.translation.width > threshold && selectedTab >= 1 {
//					
//					withAnimation(.easeInOut(duration: 0.25)) {
//						selectedTab -= 1
//					}
//				}
//			}
//	}
}


#Preview {
	MainScreen()
		.environmentObject(BaseViewModel())
		.environmentObject(SearchViewModel(searchText: ""))
		.environmentObject(PortfolioModelView())
		.environmentObject(AddCoinsToPortfolioViewModel())
		.environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
