//
//  Portfolio.swift
//  ScreenEx
//
//  Created by Anastasia on 09.04.2026.
//

import SwiftUI

struct Portfolio: View {
	@EnvironmentObject var viewModel: BaseViewModel
//	@State var searchQuery: String = ""
	@EnvironmentObject var searchViewModel: SearchViewModel

	var body: some View {
		
		NavigationStack {
			
			ZStack {
				Color.background
					.ignoresSafeArea()
				
				VStack {
					customeSearchFiel
						.padding()
					
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
										.frame(maxWidth: .infinity, alignment: .leading)
									Text("Holding")
										.frame(maxWidth: .infinity, alignment: .leading)
									
									Text("Price")
										.frame(maxWidth: .infinity, alignment: .trailing)
										.padding(.trailing, 50)
								}
							}
							
						
					}
					.animation(.easeInOut, value: viewModel.portfolioCoins)
					
					.scrollContentBackground(.hidden)
				}
				
				.navigationTitle(
					
					Text("Portfolio")
					
				)
				
			}
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				
				ToolbarItemGroup(placement: .topBarLeading) {
					NavigationLink {
						
					} label: {
						Image(systemName: "plus")
					}
					
				}
				
			}
			
		}
		
		
		
		
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
				.foregroundStyle(Color.second)
				.opacity(0.3)
			
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
