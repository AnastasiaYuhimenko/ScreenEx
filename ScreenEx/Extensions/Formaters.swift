//
//  formatters.swift
//  ScreenEx
//
//  Created by Anastasia on 05.04.2026.
//

import Foundation

extension Double {
	
	// конвертирует значение типа Double в значение типа Currency, оставляет от 2 до 6 знаков после запятой, currencySign - $
	/// ```
	/// 1234.56 -> $1,234.56
	/// 1234.123456789 -> $1,234.123456
	/// ```
	private var currencyFormatter6: NumberFormatter {
		let formatter = NumberFormatter()
		formatter.usesGroupingSeparator = true
		formatter.numberStyle = .currency
		formatter.currencyCode = "usd"
		formatter.currencySymbol = "$"
		formatter.minimumFractionDigits = 2
		formatter.maximumFractionDigits = 6
		
		return formatter
	}
	
	// конвертирует значение типа Double в значение типа String, оставляет от 2 до 6 знаков после запятой, currencySign - $
	/// ```
	/// 1234.56 -> "$1,234.56"
	/// 1234.123456789 -> "$1,234.123456"
	/// ```
	func formatCurrency6() -> String {
		let num = NSNumber(value: self)
		return currencyFormatter6.string(from: num) ?? "$0.00"
	}
	
	// конвертирует значение типа Double в тип String, оставляет 2 знака после запятой
	/// ```
	/// 1.23456 -> "1.23"
	/// ```
	func convertNumberToString2() -> String {
		return String(format: "%.2f", self)
	}
	
	// конвертирует значение типа Double в тип String, оставляет 2 знака после запятой, добавляет знак процента(%)
	/// ```
	/// 1.23456 -> "1.23%"
	/// ```
	func convertToProcent() -> String {
		return self.convertNumberToString2() + "%"
	}
}
