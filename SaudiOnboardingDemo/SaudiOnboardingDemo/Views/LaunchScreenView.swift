//
//  LaunchScreenView.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import SwiftUI

// MARK: - Launch Screen View
struct LaunchScreenView: View {
    @State private var isActive = false
    @State private var logoOpacity = 0.0
    @State private var logoScale = 0.8
    
    var body: some View {
        if isActive {
            // Main App
            RootTabView()
        } else {
            // Launch Screen
            ZStack {
                // Black Background
                Color.black
                    .ignoresSafeArea()
                
                // Logo
                Image("launch_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .opacity(logoOpacity)
                    .scaleEffect(logoScale)
            }
            .onAppear {
                // Animate logo appearance
                withAnimation(.easeOut(duration: 0.5)) {
                    logoOpacity = 1.0
                    logoScale = 1.0
                }
                
                // Transition to main app after 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isActive = true
                    }
                }
            }
        }
    }
}

// MARK: - Preview
struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
            .environmentObject(LocalizationManager.shared)
    }
}
