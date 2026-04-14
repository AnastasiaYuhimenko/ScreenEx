//
//  Resource.swift
//  ScreenEx
//
//  Created by Anastasia on 12.04.2026.
//

import Foundation

struct Resource<Response, Request: Requestable> {
	let request: Request
	let decode: (Data) throws -> Response
}

extension Resource where Response: Decodable {
	init(request: Request) {
		self.init(request: request) { data in
			try JSONDecoder().decode(Response.self, from: data)
		}
	}
}

extension Resource where Response == Void {
	init(request: Request) {
		self.init(request: request) { _ in () }
	}
}
