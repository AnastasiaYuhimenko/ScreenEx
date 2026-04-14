//
//  snakeCaseJsonDecoder.swift
//  ScreenEx
//
//  Created by Anastasia on 12.04.2026.
//

import Foundation


extension JSONDecoder {
	static var snakeCaseConverting: JSONDecoder {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		return decoder
	}
}
