//
//  NoInterner.swift
//  ScreenEx
//
//  Created by Anastasia on 25.04.2026.
//

import SwiftUI

extension View {
	var NoInternerScreen: some View {
		VStack {
			Spacer()
			Text("Oops...")
				.font(.title)
			Text("No internet connection")
				.font(.title3)
			Spacer()
			Image(systemName: "wifi.slash")
				.resizable()
				.frame(width: 100, height: 100)
			Spacer()
			Text("Pull down to retry")
				.font(.title3)
				.fontWeight(.bold)
				.foregroundStyle(Color.accent)
			
			Spacer()
		}
	}
}
