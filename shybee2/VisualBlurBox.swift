//
//  VisualBlurBox.swift
//  shybee2
//
//  Created by Taehyung Um on 4/15/25.
//

import SwiftUI

struct VisualBlurBox: View {
    var body: some View {
        ZStack {
            // 💨 시스템 블러 (회색기운 약간 있지만 베이스로 사용)
            BlurView(style: .systemUltraThinMaterial)
                .blur(radius: 5)

            // 🎨 회색 기운 보정용 베이지색 그라데이션
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#FFF9F0").opacity(0.4),
                    Color(hex: "#FFF9F0").opacity(0.8),
                    Color(hex: "#FFF9F0").opacity(1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
        // 🌓 점점 뿌얘지는 느낌: mask로 시각적 fade-in
        .mask(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.0),
                    Color.white.opacity(0.3),
                    Color.white.opacity(1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

import SwiftUI
import UIKit

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) { }
}
