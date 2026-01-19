//
//  LaunchScreenView.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import SwiftUI

// MARK: - Launch Screen View
struct LaunchScreenView: View {
    @State private var showOptions = false
    @State private var navigateToRegistration = false
    @State private var navigateToExplore = false
    @State private var showAboutUs = false
    @State private var logoOpacity = 0.0
    @State private var logoScale = 0.8
    @State private var buttonsOpacity = 0.0
    @EnvironmentObject var localizationManager: LocalizationManager
    @StateObject private var navigationManager = NavigationManager.shared
    
    var body: some View {
        Group {
            if navigateToRegistration && !navigationManager.shouldReturnToLaunch {
                ContentView()
                    .environmentObject(navigationManager)
            } else if navigateToExplore && !navigationManager.shouldReturnToLaunch {
                RootTabView()
            } else {
                splashScreen
            }
        }
        .onChange(of: navigationManager.shouldReturnToLaunch) { shouldReturn in
            if shouldReturn {
                // Reset to splash screen
                navigateToRegistration = false
                navigateToExplore = false
                showOptions = false
                logoOpacity = 0.0
                logoScale = 0.8
                buttonsOpacity = 0.0
                
                // Trigger animations again
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.easeOut(duration: 0.6)) {
                        logoOpacity = 1.0
                        logoScale = 1.0
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            showOptions = true
                        }
                        
                        withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
                            buttonsOpacity = 1.0
                        }
                    }
                }
                
                // Reset the flag
                navigationManager.resetNavigation()
            }
        }
    }
    
    // MARK: - Splash Screen
    private var splashScreen: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                colors: [Color.black, Color(white: 0.1)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // About Us Button - Top Right
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        showAboutUs = true
                    }) {
                        Text("من نحن")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                Color.white.opacity(0.15)
                                    .cornerRadius(20)
                            )
                    }
                    .padding(.top, 50)
                    .padding(.trailing, 20)
                    .opacity(buttonsOpacity)
                }
                
                Spacer()
            }
            
            VStack(spacing: 60) {
                Spacer()
                
                // Logo Section
                VStack(spacing: 20) {
                    Image("launch_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                        .opacity(logoOpacity)
                        .scaleEffect(logoScale)
                    
                    if showOptions {
                        VStack(spacing: 8) {
                            Text(LocalizedStrings.get("splash.welcome"))
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(LocalizedStrings.get("splash.subtitle"))
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        .opacity(buttonsOpacity)
                    }
                }
                
                Spacer()
                
                // Buttons Section
                if showOptions {
                    VStack(spacing: 16) {
                        // Register Button (Golden)
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                navigateToRegistration = true
                            }
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "person.badge.plus.fill")
                                    .font(.system(size: 22, weight: .semibold))
                                
                                Text(LocalizedStrings.get("splash.register"))
                                    .font(.system(size: 18, weight: .bold))
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.85, green: 0.75, blue: 0.45),
                                        Color(red: 0.75, green: 0.65, blue: 0.35)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: Color(red: 0.85, green: 0.75, blue: 0.45).opacity(0.4), radius: 15, x: 0, y: 8)
                        }
                        
                        // Explore Button (Blue/Purple)
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                navigateToExplore = true
                            }
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "building.2.fill")
                                    .font(.system(size: 22, weight: .semibold))
                                
                                Text(LocalizedStrings.get("splash.explore"))
                                    .font(.system(size: 18, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.3, green: 0.5, blue: 0.9),
                                        Color(red: 0.2, green: 0.4, blue: 0.8)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: Color.blue.opacity(0.4), radius: 15, x: 0, y: 8)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 50)
                    .opacity(buttonsOpacity)
                }
            }
        }
        .sheet(isPresented: $showAboutUs) {
            PDFViewerView(pdfName: "AboutUs")
        }
        .onAppear {
            // Animate logo first
            withAnimation(.easeOut(duration: 0.6)) {
                logoOpacity = 1.0
                logoScale = 1.0
            }
            
            // Show options after logo animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    showOptions = true
                }
                
                // Animate buttons
                withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
                    buttonsOpacity = 1.0
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
