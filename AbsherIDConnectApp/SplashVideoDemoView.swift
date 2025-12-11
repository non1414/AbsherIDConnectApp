//
//  SplashVideoDemoView.swift
//  AbsherIDConnectApp
//
//  Created by نوف بخيت الغامدي on 10/06/1447 AH.
//
import SwiftUI

struct SplashVideoDemoView: View {
    @Binding var showSplash: Bool

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.07, green: 0.20, blue: 0.03),
                    Color(red: 0.10, green: 0.32, blue: 0.08)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 80, weight: .bold))
                    .foregroundColor(.white)

                VStack(spacing: 6) {
                    Text("Video Demo")
                        .font(.system(size: 34, weight: .semibold))
                        .foregroundColor(.white)

                    Text("العرض التوضيحي")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.white.opacity(0.85))
                }

                Text("جارٍ بدء العرض…")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.top, 8)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.easeInOut) {
                    showSplash = false
                }
            }
        }
    }
}
