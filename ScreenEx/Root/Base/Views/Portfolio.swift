//
//  Portfolio.swift
//  ScreenEx
//
//  Created by Anastasia on 09.04.2026.
//

import SwiftUI

struct Portfolio: View {
	@EnvironmentObject var viewModel: BaseViewModel
	
	@EnvironmentObject var searchViewModel: SearchViewModel
	
	var body: some View {
		
		NavigationStack {
			
			ZStack {
				Color.background
					.ignoresSafeArea()
				
				List {
					Section {
							ForEach(searchViewModel.filteredCoinsPortfolio(from: viewModel.portfolioCoins)) { el in
								CoinCell(coin: el, showHoldings: true)
							}
							.onDelete { indexSet in
								let filtered = searchViewModel.filteredCoinsPortfolio(from: viewModel.portfolioCoins)
								let ids = indexSet.compactMap { filtered[$0].id }
								viewModel.deletePortfolioCoins(withIds: ids)
							}
						
					} header: {
						HStack(spacing: 0) {
							Text("Name")
								.frame(maxWidth: UIScreen.currentBounds.width / 3, alignment: .leading)
							Text("Holding")
								.frame(maxWidth: UIScreen.currentBounds.width / 3, alignment: .leading)
							
							Text("Price")
								.frame(maxWidth: UIScreen.currentBounds.width / 3, alignment: .leading)
								.padding(.trailing, 50)
								.padding(.leading, 10)
						}
					}
					
					
				}
				.refreshable {
					viewModel.refresh()
				}
				.animation(.easeInOut, value: viewModel.portfolioCoins)
				.navigationBarTitleDisplayMode(.inline)
				.navigationTitle("Portfolio")
				.toolbar {
					ToolbarItem(placement: .topBarLeading) {
						NavigationLink {
							
						} label: {
							Image(systemName: "plus")
						}
					}
				}
				.scrollContentBackground(.hidden)
				.safeAreaInset(edge: .top, spacing: 0) {
					VStack(spacing: 0) {
						customeSearchFiel
							.padding(.horizontal)
							.padding(.vertical, 8)
						
					}
				}
				.background(Color.background)
			}
			
			
		}
		.navigationBarTitleDisplayMode(.inline)
	}
}
	



#Preview {
	Portfolio()
		.environmentObject(BaseViewModel())
		.environmentObject(SearchViewModel(searchText: ""))
}

extension Portfolio {
	
	
	
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
				TextField("Search", text: $searchViewModel.searchText)
					
			}
			.padding(.horizontal)
			
		}
	}
}
