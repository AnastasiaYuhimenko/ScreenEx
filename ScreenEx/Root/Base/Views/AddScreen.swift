//
//  AddScreen.swift
//  ScreenEx
//
//  Created by Anastasia on 09.04.2026.
//

import SwiftUI

struct AddScreen: View {
	@State var searchQuery = ""
	@EnvironmentObject var viewModel: BaseViewModel
	@EnvironmentObject var searchViewModel: SearchViewModel
	@EnvironmentObject var portfolioCoinsManager: AddCoinsToPortfolioViewModel
    var body: some View {
		NavigationStack {
			ZStack {
				Color.background
					.ignoresSafeArea()
				VStack {
					CoinList
					
				}
				.safeAreaInset(edge: .top, spacing: 0) {
					VStack(spacing: 0) {
						customeSearchFiel
							.padding(.horizontal)
							.padding(.vertical, 8)
					}
				}
				
			}
			.navigationTitle("Add coin to portfolio")
			.navigationBarTitleDisplayMode(.inline)
		}
    }
}

#Preview {
    AddScreen()
		.environmentObject(AddCoinsToPortfolioViewModel())
		.environmentObject(BaseViewModel())
		.environmentObject(SearchViewModel(searchText: ""))
}

extension AddScreen {
	var CoinList: some View {
		List {
			ForEach(searchViewModel.filteredCoinsAll(from: viewModel.exchangeCoins), id: \.id) { el in
				HStack {
					HStack {
						CoinImage(imageUrl: el.image ?? "")
							.id(el.image) // подписывает на обновление coin.image
						
						VStack(alignment: .leading) {
							Text(el.name ?? "")
							
								.fontWeight(.bold)
								.foregroundStyle(Color.accent)
							Text(el.symbol ?? "")
								.foregroundStyle(Color.secondary)
						}
					}
					.frame(maxWidth: (UIScreen.currentBounds.width / 0.2), alignment: .leading)
					GlassEffectContainer {
						Button {
							portfolioCoinsManager.addCoin(id: el.id ?? "error")
						} label: {
							Image(systemName: "plus")
								.frame(width: 40, height: 40)
								.glassEffect()
						}
					}
					.disabled(portfolioCoinsManager.CoinsID.contains( el.id ?? "error" ))
				}
			}
			
		}
		.scrollContentBackground(.hidden)
	}
}

extension AddScreen {
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
