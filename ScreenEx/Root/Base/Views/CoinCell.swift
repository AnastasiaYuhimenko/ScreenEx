//
//  CoinCell.swift
//  ScreenEx
//
//  Created by Anastasia on 05.04.2026.
//

import SwiftUI


struct CoinCell: View {
	
	let coin: ExchangeModel
	let showHoldings: Bool
	
	var distance: CGFloat {
		showHoldings ? 3 : 2
	}
	
	var body: some View {
	
		HStack(spacing: 0) {
			// MARK: - Name
			HStack {
				CoinImage(imageUrl: coin.image ?? "")
					.id(coin.image) // подписывает на обновление coin.image
					
				VStack(alignment: .leading) {
					Text(coin.name ?? "")
					
						.fontWeight(.bold)
						.foregroundStyle(Color.accent)
					Text(coin.symbol ?? "")
						.foregroundStyle(Color.secondary)
				}
			}
			.frame(maxWidth: (UIScreen.currentBounds.width / distance), alignment: .leading)
			
			
	
			// MARK: - Holding
			
			if showHoldings {
				VStack(alignment: .leading) {
					Text(coin.currentHoldingsValue.formatCurrency6())
						.fontWeight(.medium)
					
					HStack(spacing: 2) {
						Text("count: ")
							.foregroundStyle(Color.secondary)
						Text("\((coin.currentHoldings ?? 0).convertNumberToString2())")
					}
				}
				.frame(maxWidth: (UIScreen.currentBounds.width / distance), alignment: .leading)
			
			}
			// MARK: - Price
			VStack(alignment: .leading) {
				Text("\((coin.currentPrice ?? 404).formatCurrency6())")
					.fontWeight(.medium)
					.foregroundStyle((coin.priceChangePercentage24H ?? 0) >= 0 ? Color.colorForPricesUp : Color.colorForPricesDown)
				
				HStack {
					Text("\((coin.priceChangePercentage24H ?? 0).convertToProcent())")
						.foregroundStyle((coin.priceChangePercentage24H ?? 0) >= 0 ? Color.colorForPricesUp : Color.colorForPricesDown)
					
					Image(systemName: (coin.priceChangePercentage24H ?? 0) >= 0 ? "arrow.up" : "arrow.down")
						.foregroundStyle((coin.priceChangePercentage24H ?? 0) >= 0 ? Color.colorForPricesUp : Color.colorForPricesDown)
						.font(.system(size: 15))
						.offset(y: 1)
				}
			}
			.frame(maxWidth: UIScreen.currentBounds.width / distance, alignment: .leading)
			.padding(.leading, 10)
		}
		.lineLimit(1)
	}
}

#Preview {
	ZStack {
		Color.background
			.ignoresSafeArea()
		
		VStack {
			List {
				Section {
					ForEach(0..<1) { idx in
						CoinCell(coin: CoinPreviewModel.shared.coin, showHoldings: true)
						
					}
					.onDelete{ index in
						
					}
				} header: {
					HStack(spacing: 0) {
						Text("Name")
							.frame(maxWidth: .infinity, alignment: .leading)
						Text("Holding")
							.frame(maxWidth: .infinity, alignment: .leading)
						
						Text("Price")
//							.frame(maxWidth: .infinity, alignment: .trailing)
							.frame(maxWidth: UIScreen.currentBounds.width / 3, alignment: .leading)
//							.padding(.trailing, 50)
					}
				}
				
			}
			
			.scrollContentBackground(.hidden)
			
		}
	}
}

