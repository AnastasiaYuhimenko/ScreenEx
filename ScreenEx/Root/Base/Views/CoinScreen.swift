//
//  CoinScreen.swift
//  ScreenEx
//
//  Created by Anastasia on 26.04.2026.
//

import SwiftUI

struct CoinScreen: View {
	@EnvironmentObject var baseViewModel: BaseViewModel
    var body: some View {
		ZStack {
			// MARK: - background
			Color.background
				.ignoresSafeArea()
			
			// MARK: - content
			
			RoundedRectangle(cornerRadius: 26)
				.foregroundStyle(Color.white)
				.padding()
				.padding(.horizontal, 8)
		}
    }
}

#Preview {
    CoinScreen()
		.environmentObject(BaseViewModel())
}
