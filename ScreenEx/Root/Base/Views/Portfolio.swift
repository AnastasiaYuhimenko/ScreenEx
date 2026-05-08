//
//  Portfolio.swift
//  ScreenEx
//
//  Created by Anastasia on 09.04.2026.
//

import SwiftUI
import CoreData
import UIKit

struct Portfolio: View {
	@Environment(\.managedObjectContext) private var managedObjectContext
	@EnvironmentObject var viewModel: PortfolioModelView
	@EnvironmentObject var coinManager: AddCoinsToPortfolioViewModel
	@StateObject var searchViewModel: SearchViewModel
	@FocusState private var isSearchFieldFocused: Bool
	
	var body: some View {
		
		NavigationStack {
			
			ZStack {
				
				// MARK: - background
				Color.background
					.ignoresSafeArea()
				
				// MARK: - content
				if let urlError = viewModel.loadError as? URLError,
				   urlError.code == .notConnectedToInternet {
					ScrollView {
						NoInternerScreen
							.frame(maxWidth: .infinity)
							.frame(minHeight: UIScreen.currentBounds.height * 0.7)
						
					}
					.refreshable {
						viewModel.refresh(coinsID: coinManager.CoinsID)
					}					} else if viewModel.portfolioCoins.isEmpty && !viewModel.isLoading && !searchViewModel.isLoading {
						NoCoins
					} else if !viewModel.isLoading && !searchViewModel.isLoading {
						portfolioCoinsList
					} else  if let urlError = viewModel.loadError as? URLError,
							   urlError.code == .notConnectedToInternet
				{
						NoInternerScreen
				}
				else {
					Spacer()
					ProgressView()
					Spacer()
				}
				
				
			}
			.navigationTitle("Portfolio")
			.navigationBarTitleDisplayMode(.inline)
			.safeAreaInset(edge: .top, spacing: 0) {
				VStack(spacing: 0) {
					if !viewModel.portfolioCoins.isEmpty {
						customeSearchField
							.padding(.horizontal)
							.padding(.vertical, 8)
					}
				}
			}
			
		}
		.onAppear {
			coinManager.fetchCoinsFromCoreData(context: managedObjectContext)
			viewModel.refresh(coinsID: coinManager.CoinsID)
		}
		.onChange(of: coinManager.CoinsID.map(\.0)) { _ in
			viewModel.refresh(coinsID: coinManager.CoinsID)
		}
		//			.contentShape(Rectangle())
		//			.onTapGesture {
		//				hideKeyboardAndResetFocus()
		//			}
		.navigationBarTitleDisplayMode(.inline)
		
		
	}
	
}


#Preview {
	Portfolio(searchViewModel: SearchViewModel(searchText: ""))
		.environmentObject(AddCoinsToPortfolioViewModel())
		.environmentObject(PortfolioModelView())
		.environmentObject(BaseViewModel())
		.environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
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
					.focused($isSearchFieldFocused)
					
			}
			.padding(.horizontal)
			
		}
		
	}

	private func hideKeyboardAndResetFocus() {
		isSearchFieldFocused = false
		UIApplication.shared.sendAction(
			#selector(UIResponder.resignFirstResponder),
			to: nil,
			from: nil,
			for: nil
		)
	}
}


extension Portfolio {
	var portfolioCoinsList: some View {
		
		List {
			Section {
				ForEach(searchViewModel.filteredCoinsPortfolio(from: viewModel.portfolioCoins)) { el in
					CoinCell(coin: el, showHoldings: true)
					
				}
				.onDelete { indexSet in
					let filtered = searchViewModel.filteredCoinsPortfolio(from: viewModel.portfolioCoins)
					let ids = indexSet.compactMap { filtered[$0].id }
					if let firstId = ids.first {
						coinManager.deleteCoin(id: firstId, context: managedObjectContext)
					}
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
		.simultaneousGesture(
			TapGesture().onEnded {
				hideKeyboardAndResetFocus()
			}
		)
		.onDisappear {
			hideKeyboardAndResetFocus()
		}
		.refreshable {
			viewModel.refresh(coinsID: coinManager.CoinsID)
		}
		.scrollContentBackground(.hidden)
		.animation(.spring(duration: 1), value: viewModel.isLoading)
		.toolbar {
			ToolbarItem(placement: .topBarLeading) {
				NavigationLink {
					AddScreen(searchViewModel: SearchViewModel(searchText: ""))
				} label: {
					Image(systemName: "plus")
				}
			}
		}
	}
}

extension Portfolio {
	var NoCoins: some View {
		NavigationStack {
			ZStack {
				
				Color.background
					.ignoresSafeArea()
				
				VStack {
					Spacer()
					Text("You don’t have any coins yet")
						.font(.title)
						.fontWeight(.bold)
						.multilineTextAlignment(.center)
						.padding()
					Text("Add your first coin to get started")
						.font(.title3)
						.frame(width: 300)
						.multilineTextAlignment(.center)
						.lineLimit(2, reservesSpace: true)
						.padding(.bottom)
					
					
					NavigationLink(destination: AddScreen(searchViewModel: SearchViewModel(searchText: ""))) {
						ZStack {
							RoundedRectangle(cornerRadius: 20)
								.frame(width: 230, height: 50)
							Text("Add your first coin")
								.foregroundStyle(Color.white)
								.fontWeight(.bold)
						}
					}
					
					Spacer()
				}
				.padding()
			}
		}
	}
}
