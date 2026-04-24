//
//  TopCoinsScreen.swift
//  ScreenEx
//
//  Created by Anastasia on 09.04.2026.
//

import SwiftUI

struct TopCoinsScreen: View {
	@EnvironmentObject var viewModel: BaseViewModel
	@EnvironmentObject var searchViewModel: SearchViewModel
	
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
						Spacer()
						ProgressView()
						Spacer()
					}
					
				}
				.safeAreaInset(edge: .top, spacing: 0) {
					VStack(spacing: 0) {
						customeSearchFiel
							.padding(.horizontal)
							.padding(.vertical, 8)
					}
				}
				.navigationTitle(
					Text("Top")
				)
				.navigationBarTitleDisplayMode(.inline)
			}
		
		}
	}
}

#Preview {
	TopCoinsScreen()
		.environmentObject(BaseViewModel())
		.environmentObject(SearchViewModel(searchText: ""))
}

extension TopCoinsScreen {
	var customeSearchFiel: some View {
		ZStack {
			Capsule()
				.frame(height: 50)
				.foregroundStyle(Color.searchGlass)
				.glassEffect()
			
			
			HStack {
				Image(systemName: "magnifyingglass")
					.foregroundStyle(Color.accent)
				TextField("Search", text: $searchViewModel.searchText)
					.textInputAutocapitalization(.never)
					.autocorrectionDisabled(true)
				
			}
			.padding(.horizontal)
			
		}
	}
}


extension TopCoinsScreen {
	
	var coinsList: some View {
		List {
			Section {
				
				ForEach(Array(searchViewModel.filteredCoinsAll(from: viewModel.exchangeCoins).enumerated()), id: \.offset) { _, el in
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
		.animation(.easeInOut, value: viewModel.exchangeCoins)
		.scrollContentBackground(.hidden)
	}
}
