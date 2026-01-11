//
//  DesignConstants.swift
//  SaudiOnboardingDemo
//
//  Created on 2026-01-11
//

import SwiftUI

// MARK: - Design Constants
enum DesignConstants {
    
    // MARK: - Layout
    /// Standard horizontal gutter/padding for content (safe from edges)
    static let horizontalGutter: CGFloat = 24
    
    /// Card padding
    static let cardPadding: CGFloat = 16
    
    /// Section spacing
    static let sectionSpacing: CGFloat = 24
    
    // MARK: - Corner Radius
    static let cardCornerRadius: CGFloat = 20
    static let smallCornerRadius: CGFloat = 12
    static let buttonCornerRadius: CGFloat = 12
    
    // MARK: - Shadows
    static func cardShadow() -> some View {
        EmptyView()
            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
    
    static func lightShadow() -> some View {
        EmptyView()
            .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 1)
    }
}

// MARK: - View Extension for Consistent Padding
extension View {
    /// Apply standard horizontal content padding
    func contentPadding() -> some View {
        self.padding(.horizontal, DesignConstants.horizontalGutter)
    }
    
    /// Apply card styling
    func cardStyle() -> some View {
        self
            .background(Color(UIColor.systemBackground))
            .cornerRadius(DesignConstants.cardCornerRadius)
            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
}
