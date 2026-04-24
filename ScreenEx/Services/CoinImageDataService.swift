//
//  CoinImageDataService.swift
//  ScreenEx
//
//  Created by Anastasia on 14.04.2026.
//

import Foundation
import UIKit
import Combine

class CoinImageDataService: ObservableObject {
	
	@Published var coinImage: UIImage? = nil
	@Published var isLoading: Bool = false
	@Published var error: Error?

	private let apiClient: APIClient

	init(urlString: String, apiClient: APIClient = .init()) {
		self.apiClient = apiClient
		getCoinImage(urlString: urlString)
	}
	
	private func getCoinImage(urlString: String) {
		let resource = Resource<UIImage, ImageRequest>(request: ImageRequest(urlString: urlString)) { data in
			guard let image = UIImage(data: data) else {
				throw URLError(.cannotDecodeContentData)
			}
			return image
		}

		Task {
			await MainActor.run {
				isLoading = true
				error = nil
			}
			print("🖼️ [CoinImageDataService] Starting image request...")

			do {
				let image = try await apiClient.dataTask(with: resource)
				print("🖼️ [CoinImageDataService] ✅ Image loaded successfully")
				await MainActor.run {
					coinImage = image
					isLoading = false
					error = nil
				}
			} catch {
				await MainActor.run {
					self.error = error
					isLoading = false
				}
				print("🖼️ [CoinImageDataService] ❌ Error: \(error.localizedDescription)")
				
			}
		}
		
		
	}
}

private struct ImageRequest: Requestable {
	let urlString: String
	var path: String { urlString }
	
	var headers: [HTTPHeaderKey: String] {
		[
			.coinGeckoDemoAPIKey: AppConstants.CoinGecko.demoAPIKey
		]
	}
	var timeoutInterval: TimeInterval? { 10 }
}



private extension HTTPHeaderKey {
	static let coinGeckoDemoAPIKey = HTTPHeaderKey("x-cg-demo-api-key")
}
