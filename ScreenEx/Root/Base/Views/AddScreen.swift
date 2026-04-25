//
//  AddScreen.swift
//  ScreenEx
//
//  Created by Anastasia on 09.04.2026.
//

import SwiftUI
import UIKit
import CoreData

struct AddScreen: View {
	@Environment(\.managedObjectContext) private var managedObjectContext
	@State var searchQuery = ""
	@State var showingCount: String = ""
	@EnvironmentObject var viewModel: BaseViewModel
	@StateObject var searchViewModel: SearchViewModel
	@EnvironmentObject private var coinManager: AddCoinsToPortfolioViewModel
	
	@State var count: String = ""
	@FocusState private var isSearchFieldFocused: Bool
	@FocusState private var isCountFieldFocused: Bool
	
	
	@State var addCount: Double = 0.0
	
    var body: some View {
		NavigationStack {
			ZStack {
				Color.background
					.ignoresSafeArea()
					.onTapGesture {
						hideKeyboardAndResetFocus()
					}

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
			.onDisappear {
				hideKeyboardAndResetFocus()
			}
			.onAppear {
				hideKeyboardAndResetFocus()
			}
		}
    }
}

#Preview {
	AddScreen(searchViewModel: SearchViewModel(searchText: ""))
		.environmentObject(AddCoinsToPortfolioViewModel())
		.environmentObject(BaseViewModel())
		.environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}

extension AddScreen {
	var CoinList: some View {
		List {
			ForEach(searchViewModel.filteredCoinsAll(from: viewModel.exchangeCoins), id: \.id) { el in
				HStack {
					HStack {
						CoinImage(imageUrl: el.image ?? "")
							.id(el.image) // NOTE: подписывает на обновление coin.image
						
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
								withAnimation(.spring()) {
									if showingCount == el.id {
										addCount = Double(count ?? "0") ?? 0.0
										// TODO: добавить проверку на адекватность count
										coinManager.addCoin(id: el.id ?? "error", count: addCount, context: managedObjectContext)
										showingCount = ""
										isCountFieldFocused = false
									} else {
										showingCount = el.id ?? ""
										count = ""
									}
								}
							} label: {
								Image(systemName: showingCount == el.id ? "checkmark" : "plus")
									.frame(width: 40, height: 40)
									.glassEffect()
							}
						
					}
					.disabled(coinManager.CoinsID.contains(where: { $0.0 == el.id ?? "" }))
					.animation(.spring)
					TextField("0.0", text: $count)
						.textFieldStyle(.roundedBorder)
						.focused($isCountFieldFocused)
						.frame(width: showingCount == el.id ? 90 : 0)
						.opacity(showingCount == el.id ? 1 : 0)
						.scaleEffect(showingCount == el.id ? 1 : 0.8, anchor: .trailing)
						.allowsHitTesting(showingCount == el.id)
						.animation(.spring(response: 0.35, dampingFraction: 0.8), value: showingCount)
						.gesture(
							DragGesture(minimumDistance: 20)
								.onEnded{ value in
									handleSwipe(value: value)
								}
						)
				}
			}
			
		}
		.scrollContentBackground(.hidden)
		.scrollDismissesKeyboard(.immediately)
	}
}

extension AddScreen {
	var customeSearchFiel: some View {
		VStack {
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
	}
}


extension AddScreen {
	
	private func handleSwipe(value: DragGesture.Value) {
			let dx = value.translation.width
			let dy = value.translation.height
			if abs(dx) > abs(dy) {
				if dx > 0 {
					dismissKeyboard()
					// TODO: поспрашивать у людей выглядит ли это как баг и если да, то убрать
					showingCount = ""
					count = ""
					
					isCountFieldFocused = false
				} else {
					return
				}
			} else {
				return
			}
		}

	private func dismissKeyboard() {
		UIApplication.shared.sendAction(
			#selector(UIResponder.resignFirstResponder),
			to: nil,
			from: nil,
			for: nil
		)
	}

	private func hideKeyboardAndResetFocus() {
		isSearchFieldFocused = false
		isCountFieldFocused = false
		dismissKeyboard()
	}
	
}
