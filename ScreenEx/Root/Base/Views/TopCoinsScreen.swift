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
				Color.background
					.ignoresSafeArea()
				
				VStack {
					customeSearchFiel
						.padding()
					
					List {
						Section {
									ForEach(Array(viewModel.exchangeCoins.enumerated()), id: \.offset) { _, el in
										CoinCell(coin: el, showHoldings: false)
									}
								
							} header: {
								HStack(spacing: 0) {
									Text("Name")
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
				.foregroundStyle(Color.second)
				.opacity(0.3)
			
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
