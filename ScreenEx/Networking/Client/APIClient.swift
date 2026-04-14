//
//  APIClient.swift
//  ScreenEx
//
//  Created by Anastasia on 12.04.2026.
//

import Foundation

struct RetryConfiguration {
	let maxAttempts: Int
	let initialDelay: TimeInterval
	let multiplier: Double
	let maxDelay: TimeInterval

	static let `default` = RetryConfiguration(
		maxAttempts: 10,
		initialDelay: 0.5,
		multiplier: 2.0,
		maxDelay: 10.0
	)

	func delay(for attempt: Int) -> TimeInterval {
		let delay = initialDelay * pow(multiplier, Double(attempt))
		return min(delay, maxDelay)
	}
}

final class APIClient {
	private let baseURL: URL
	private let urlSession: URLSession
	private let retryConfiguration: RetryConfiguration

	init(
		baseURL: URL = URL(string: "https://api.coingecko.com/api/v3/")!,
		urlSession: URLSession = .shared,
		retryConfiguration: RetryConfiguration = .default
	) {
		self.baseURL = baseURL
		self.urlSession = urlSession
		self.retryConfiguration = retryConfiguration
	}

	func dataTask<Response, Request>(
		with resource: Resource<Response, Request>
	) async throws -> Response {
		var lastError: Error?

		print("🌐 [APIClient] Starting request for resource")

		for attempt in 0 ..< retryConfiguration.maxAttempts {
			print("🔄 [APIClient] Attempt \(attempt + 1)/\(retryConfiguration.maxAttempts)")

			do {
				var urlRequest = try URLRequest(request: resource.request, baseURL: baseURL)
				urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData

				print("🌐 [APIClient] URL: \(urlRequest.url?.absoluteString ?? "unknown")")

				let (data, response) = try await urlSession.data(for: urlRequest)
				guard let http = response as? HTTPURLResponse else {
					print("❌ [APIClient] Invalid response type")
					throw URLError(.badServerResponse)
				}

				print("📥 [APIClient] Received status code: \(http.statusCode)")

				if (200 ..< 300).contains(http.statusCode) {
					print("✅ [APIClient] Request successful")
					return try resource.decode(data)
				}

				if Self.isRetryableStatusCode(http.statusCode) {
					print("⚠️ [APIClient] Retryable status code: \(http.statusCode)")
					throw URLError(.badServerResponse)
				}

				print("❌ [APIClient] Non-retryable status code: \(http.statusCode)")
				throw URLError(.badServerResponse)
			} catch {
				lastError = error
				let isRetryable = Self.isRetryableError(error)
				print("❌ [APIClient] Error: \(error.localizedDescription), retryable: \(isRetryable)")

				guard isRetryable,
					  attempt < retryConfiguration.maxAttempts - 1
				else {
					print("🛑 [APIClient] Giving up after \(attempt + 1) attempts")
					throw error
				}

				let delay = retryConfiguration.delay(for: attempt)
				print("⏳ [APIClient] Waiting \(String(format: "%.1f", delay))s before retry...")
				try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
			}
		}

		print("🛑 [APIClient] All attempts exhausted")
		throw lastError ?? URLError(.unknown)
	}

	private static func isRetryableError(_ error: Error) -> Bool {
		guard let urlError = error as? URLError else { return false }

		let retryableCodes: [URLError.Code] = [
			.timedOut,
			.cannotFindHost,
			.cannotConnectToHost,
			.networkConnectionLost,
			.dnsLookupFailed,
			.notConnectedToInternet,
			.secureConnectionFailed,
			.dataNotAllowed
		]

		return retryableCodes.contains(urlError.code)
	}

	private static func isRetryableStatusCode(_ statusCode: Int) -> Bool {
		[408, 429, 500, 502, 503, 504].contains(statusCode)
	}
}
