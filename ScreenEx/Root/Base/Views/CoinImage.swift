//
//  CoinImage.swift
//  ScreenEx
//
//  Created by Anastasia on 14.04.2026.
//

import SwiftUI

struct CoinImage: View {
	@StateObject private var imageService: CoinImageDataService
	init(imageUrl: String) {
		_imageService = StateObject(wrappedValue: CoinImageDataService(urlString: imageUrl))
	}
	var body: some View {
		ZStack {
			Circle()
				.fill(Color.gray.opacity(0.15))
				.frame(width: 40, height: 40)

			if let image = imageService.coinImage {
				Image(uiImage: image)
					.resizable()
					.scaledToFill()
					.frame(width: 40, height: 40)
					.clipShape(Circle())
					.transition(.opacity)
			} else if imageService.error != nil {
				Image(systemName: "exclamationmark.triangle")
					.foregroundStyle(.secondary)
			} else {
				ProgressView()
					.controlSize(.small)
			}
		}
		.frame(width: 40, height: 40)
		.animation(.easeInOut(duration: 0.2), value: imageService.coinImage)
	}
}

#Preview {
    CoinImage(imageUrl: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579")
}
