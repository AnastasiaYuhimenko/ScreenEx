//
//  JSONEncoderSnc.swift
//  ScreenEx
//
//  Created by Anastasia on 12.04.2026.
//

import Foundation


extension JSONEncoder {
	static var snakeCaseConverting: JSONEncoder {
		let encoder = JSONEncoder()
		encoder.keyEncodingStrategy = .convertToSnakeCase
		return encoder
	}
}
