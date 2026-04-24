//
//  LaunchScreen.swift
//  ScreenEx
//
//  Created by Anastasia on 19.04.2026.
//

import SwiftUI

struct LaunchScreen: View {
	@State private var compact = false

	var body: some View {
		ZStack {
			Color(#colorLiteral(red: 0.1450980392, green: 0.3647058824, blue: 0.1960784314, alpha: 1))
				.ignoresSafeArea()

			VStack(spacing: compact ? 0 : 16) {
				Image("lotty")
					.resizable()
					.scaledToFit()
					.frame(maxWidth: compact ? 300 : 760)

				if !compact {
					Text("ScreenEX")
						.fontWeight(.bold)
						.foregroundStyle(Color.white)
						.font(.largeTitle)
				}
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: compact ? .center : .top)
			.padding(.top, compact ? 0 : 100)
		}
		.onAppear {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
				withAnimation(.spring(response: 0.55, dampingFraction: 0.85)) {
					compact = true
				}
			}
		}
	}
}

#Preview {
	LaunchScreen()
}
