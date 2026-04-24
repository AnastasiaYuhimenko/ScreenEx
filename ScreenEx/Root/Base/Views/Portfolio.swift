//
//  Portfolio.swift
//  ScreenEx
//
//  Created by Anastasia on 09.04.2026.
//

import SwiftUI

struct Portfolio: View {
	@EnvironmentObject var viewModel: PortfolioModelView
	@EnvironmentObject var coinManager: AddCoinsToPortfolioViewModel
	@EnvironmentObject var searchViewModel: SearchViewModel
	
	var body: some View {
		
		NavigationStack {
			
			ZStack {
				
				// MARK: - background
				Color.background
					.ignoresSafeArea()
				
				// MARK: - content
				List {
					Section {
						if viewModel.isLoading || searchViewModel.isLoading {
							Group {
//								Spacer()
								ProgressView()
//								Spacer()
							}
							.transition(.opacity)
						} else {
							portfolioCoinsList
								.transition(.opacity)
						}
					} header : {
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
					viewModel.refresh(coinsID: coinManager.CoinsID)
				}
				.onChange(of: coinManager.CoinsID) { _  in
					viewModel.refresh(coinsID: coinManager.CoinsID)
				}
				.scrollContentBackground(.hidden)
				.animation(.spring(duration: 1), value: viewModel.isLoading)
				.toolbar {
					ToolbarItem(placement: .topBarLeading) {
						NavigationLink {
							AddScreen()
						} label: {
							Image(systemName: "plus")
						}
					}
				}
				.navigationTitle("Portfolio")
				.navigationBarTitleDisplayMode(.inline)
				.safeAreaInset(edge: .top, spacing: 0) {
					VStack(spacing: 0) {
						customeSearchField
							.padding(.horizontal)
							.padding(.vertical, 8)
					}
				}
				
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		
	}
}
	



#Preview {
	Portfolio()
		.environmentObject(AddCoinsToPortfolioViewModel())
		.environmentObject(PortfolioModelView())
		.environmentObject(BaseViewModel())
		.environmentObject(SearchViewModel(searchText: ""))
}

extension Portfolio {
	var customeSearchField: some View {
		
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


extension Portfolio {
	var portfolioCoinsList: some View {
//		List {
//			Section {
					ForEach(searchViewModel.filteredCoinsPortfolio(from: viewModel.portfolioCoins)) { el in
						CoinCell(coin: el, showHoldings: true)
							
					}
					.onDelete { indexSet in
						let filtered = searchViewModel.filteredCoinsPortfolio(from: viewModel.portfolioCoins)
						let ids = indexSet.compactMap { filtered[$0].id }
						if let firstId = ids.first {
							coinManager.deleteCoin(id: firstId)
						    
						}
					}
//				
//			} header: {
//				
//			}
//			
//			
//			
//		}
//		.refreshable {
//			viewModel.refresh(coinsID: coinManager.CoinsID)
//		}
//		.onChange(of: coinManager.CoinsID) { _  in
//			viewModel.refresh(coinsID: coinManager.CoinsID)
//		}
//		.scrollContentBackground(.hidden)
//	
	}
}
