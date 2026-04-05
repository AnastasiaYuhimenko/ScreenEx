//
//  AppColors.swift
//  ScreenEx
//
//  Created by Anastasia on 04.04.2026.
//
// кажется на момент написания данного кода это больше не нужно и цвета можно вызывать просто Color.name :)


import Foundation
import SwiftUI

extension Color {
	
	static let appColor = AppColors()
	
}

struct AppColors {
	let accentAppColor = Color("AccentColor")
	let backgroundColor = Color("colorForBackground")
	let pricesDown = Color("colorForPricesDown")
	let pricesUp = Color("colorForPricesUp")
	let secodaryColor = Color("ColorForText")
}
