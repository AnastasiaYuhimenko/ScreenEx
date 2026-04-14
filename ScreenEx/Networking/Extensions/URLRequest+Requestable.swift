//
//  URLRequest+Requestable.swift
//  ScreenEx
//
//  Created by Anastasia on 12.04.2026.
//

import Foundation

extension URLRequest {
	init(request: some Requestable, baseURL: URL) throws {
		guard let fullURL = request.fullURL(baseURL: baseURL) else {
			throw NSError(
				domain: "com.AnastasiaYukhimenko.ScreenEx.Networking", 
				code: 0,
				userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]
			)
		}

		self.init(url: fullURL)
		httpMethod = request.method.rawValue

		if let timeout = request.timeoutInterval {
			self.timeoutInterval = timeout
		}

		for (key, value) in request.headers {
			addValue(value, forHTTPHeaderField: key.rawValue)
		}
	}
}
