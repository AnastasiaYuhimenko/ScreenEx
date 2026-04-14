//
//  Requestable.swift
//  ScreenEx
//
//  Created by Anastasia on 12.04.2026.
//

import Foundation

enum HTTPMethod: String {
	case GET
	case POST
	case PUT
	case DELETE
}

protocol Requestable {
	associatedtype Body: Encodable = Never
	var method: HTTPMethod { get }
	var path: String { get }
	var parameters: [URLQueryItem] { get }
	var headers: [HTTPHeaderKey: String] { get }
	var body: Body? { get }
	/// When set, applied to `URLRequest.timeoutInterval`.
	var timeoutInterval: TimeInterval? { get }

	func fullURL(baseURL: URL) -> URL?
}

extension Requestable {
	var method: HTTPMethod { .GET }
	var parameters: [URLQueryItem] { [] }
	var headers: [HTTPHeaderKey: String] { [:] }
	var body: Never? { nil }
	var timeoutInterval: TimeInterval? { nil }

	func fullURL(baseURL: URL) -> URL? {
		guard let url = URL(string: path, relativeTo: baseURL),
			  var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
		else { return nil }

		if !parameters.isEmpty {
			urlComponents.queryItems = parameters
		}

		return urlComponents.url
	}
}
