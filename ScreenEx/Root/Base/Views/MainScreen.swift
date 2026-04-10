//
//  mainScreen.swift
//  ScreenEx
//
//  Created by Anastasia on 09.04.2026.
//

import SwiftUI

struct MainScreen: View {
	
	@State var selectedTab: Int = 0
	@EnvironmentObject private var viewModel: BaseViewModel
	
    var body: some View {
		ZStack {
			Color.background
				.ignoresSafeArea()
			
			TabView(selection: $selectedTab) {
				Tab("Portfolio", systemImage: "basket", value: 0) {
					Portfolio()
						.gesture(swipeGesture(), including: .gesture)
				}
				
				
				Tab("Top", systemImage: "chart.line.uptrend.xyaxis", value: 1) {
					TopCoinsScreen()
						.gesture(swipeGesture(), including: .gesture)
				}
				
			}
		
			
			
		}
    }
}

#Preview {
    MainScreen()
		.environmentObject(BaseViewModel())
		.environmentObject(SearchViewModel(searchText: ""))
}

extension MainScreen {
	func swipeGesture() -> some Gesture {
		DragGesture(minimumDistance: 20)
			.onEnded { value in
				let threshold: CGFloat = 50
				let isHorizontalSwipe = abs(value.translation.width) > abs(value.translation.height)
				
				guard isHorizontalSwipe else { return }
				
				if (value.translation.width < -threshold) && selectedTab < 1  {
					selectedTab += 1
				} else if (value.translation.width > threshold) && selectedTab >= 1 {
					selectedTab -= 1
				}
			}
	}
}
