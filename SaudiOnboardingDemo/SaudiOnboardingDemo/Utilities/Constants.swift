//
//  Constants.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import SwiftUI

struct AppColors {
    static let primary = Color(hex: "#D4AF37")
    static let secondary = Color(hex: "#B8941E")
    static let background = Color(UIColor.systemGroupedBackground)
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
    static let error = Color(hex: "#DC3545")
    static let success = Color(hex: "#28A745")
    static let cardBackground = Color(UIColor.systemBackground)
}

struct AppConstants {
    static let totalSteps = 9 // من 0 إلى 8
    static let cornerRadius: CGFloat = 12
    static let cardPadding: CGFloat = 16
    static let spacing: CGFloat = 16
}

// Extension لتحويل Hex إلى Color
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
