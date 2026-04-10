//
//  AddScreen.swift
//  ScreenEx
//
//  Created by Anastasia on 09.04.2026.
//

import SwiftUI

struct AddScreen: View {
	@State var searchQuery = ""
    var body: some View {
		ZStack {
			Color.background
				.ignoresSafeArea()
			VStack {
				customeSearchFiel
			}
			.padding()
		}
		
    }
}

#Preview {
    AddScreen()
}

extension AddScreen {
	var customeSearchFiel: some View {
		ZStack {
			Capsule()
				.frame(height: 50)
				.foregroundStyle(Color.second)
				.opacity(0.3)
			
			HStack {
				Button {
					
				} label: {
					Image(systemName: "magnifyingglass")
				}
				TextField("Search", text: $searchQuery)
					
			}
			.padding(.horizontal)
			
		}
	}
}
