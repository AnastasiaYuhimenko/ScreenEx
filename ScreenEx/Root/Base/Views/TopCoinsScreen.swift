//
//  TopCoinsScreen.swift
//  ScreenEx
//
//  Created by Anastasia on 09.04.2026.
//

import SwiftUI

struct TopCoinsScreen: View {
	@EnvironmentObject var viewModel: BaseViewModel
	@State var searchQuery: String = ""

	var body: some View {
		
		NavigationStack {
			
			ZStack {
				
				// MARK: - background
				Color.background
					.ignoresSafeArea()
				
				// MARK: - content
				VStack {
			    if viewModel.isLoading != true {
					coinsList
				} else {
					ProgressView()
							.progressViewStyle(CircularProgressViewStyle(tint: .white))
				}
				
				}
				.navigationTitle(
					Text("Top")
				)
			}
			.navigationBarTitleDisplayMode(.inline)
		}
	}
}

#Preview {
	TopCoinsScreen()
		.environmentObject(BaseViewModel())
}

extension TopCoinsScreen {
	var customeSearchFiel: some View {
		ZStack {
			Capsule()
				.frame(height: 50)
				.foregroundStyle(Color.searchGlass)
			
			
			HStack {
				Button {
					
				} label: {
					Image(systemName: "magnifyingglass")
				}
				TextField("Search", text: $searchQuery)
					
			}
			.padding(.horizontal)
			
		}
	}
}


extension TopCoinsScreen {
	
	var coinsList: some View {
		List {
			Section {
				
				ForEach(Array(viewModel.exchangeCoins.enumerated()), id: \.offset) { _, el in
					CoinCell(coin: el, showHoldings: false)
				}
				.listRowSeparator(.visible)
				
			} header: {
				HStack(spacing: 0) {
					Text("Name")
						.frame(maxWidth: .infinity, alignment: .leading)
						.frame(maxWidth: UIScreen.currentBounds.width / 2, alignment: .leading)
					Text("Price")
						.frame(maxWidth: UIScreen.currentBounds.width / 2, alignment: .leading)
						.padding(.trailing, 50)
						.padding(.leading, 10)
				}
			}
			.listSectionSeparator(.hidden, edges: .top)
			.listSectionSeparator(.hidden, edges: .bottom)
		}
		
		
		.refreshable {
			viewModel.refresh()
		}
		.animation(.easeInOut, value: viewModel.portfolioCoins)
		.safeAreaInset(edge: .top, spacing: 0) {
			VStack(spacing: 0) {
				customeSearchFiel
					.padding(.horizontal)
					.padding(.vertical, 8)
			}
		}
		.scrollContentBackground(.hidden)
	}
}
