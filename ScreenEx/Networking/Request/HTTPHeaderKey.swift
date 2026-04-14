//
//  HTTPHeaderKey.swift
//  ScreenEx
//
//  Created by Anastasia on 12.04.2026.
//

import Foundation

struct HTTPHeaderKey: ExpressibleByStringLiteral, Hashable {
	let rawValue: String

	init(stringLiteral value: String) { rawValue = value }
}

extension HTTPHeaderKey {
	static let contentType = HTTPHeaderKey("Content-Type")
	static let accept = HTTPHeaderKey("Accept")
	static let authorization = HTTPHeaderKey("Authorization")
}
