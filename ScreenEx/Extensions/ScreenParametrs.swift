//
//  ScreenParametrs.swift
//  ScreenEx
//
//  Created by Anastasia on 13.04.2026.
//

import Foundation
import SwiftUI

extension UIScreen {
	static var currentBounds: CGRect {
		UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
			.first?.screen.bounds ?? .zero
	}
}
