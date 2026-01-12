//
//  ThemeManager.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import Foundation
import SwiftUI
import Combine

// MARK: - Theme Mode
enum ThemeMode: String, CaseIterable {
    case light = "light"
    case dark = "dark"
    case system = "system"
    
    var displayName: String {
        let language = LocalizationManager.shared.currentLanguage
        switch self {
        case .light:
            return language == .arabic ? "فاتح" : "Light"
        case .dark:
            return language == .arabic ? "داكن" : "Dark"
        case .system:
            return language == .arabic ? "النظام" : "System"
        }
    }
    
    var icon: String {
        switch self {
        case .light:
            return "sun.max.fill"
        case .dark:
            return "moon.fill"
        case .system:
            return "circle.lefthalf.filled"
        }
    }
}

// MARK: - Theme Manager
class ThemeManager: ObservableObject {
    
    // MARK: - Singleton
    static let shared = ThemeManager()
    
    // MARK: - Published Properties
    @Published var currentTheme: ThemeMode {
        didSet {
            UserDefaults.standard.set(currentTheme.rawValue, forKey: "app_theme")
            applyTheme()
        }
    }
    
    @Published var isDarkMode: Bool = false
    
    // MARK: - Initialization
    private init() {
        // Load saved theme or default to system
        let savedTheme = UserDefaults.standard.string(forKey: "app_theme") ?? ThemeMode.system.rawValue
        self.currentTheme = ThemeMode(rawValue: savedTheme) ?? .system
        applyTheme()
    }
    
    // MARK: - Public Methods
    func toggleTheme() {
        switch currentTheme {
        case .light:
            currentTheme = .dark
        case .dark:
            currentTheme = .light
        case .system:
            currentTheme = .dark
        }
    }
    
    func setTheme(_ theme: ThemeMode) {
        withAnimation {
            currentTheme = theme
        }
    }
    
    // MARK: - Private Methods
    private func applyTheme() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            
            switch self.currentTheme {
            case .light:
                window?.overrideUserInterfaceStyle = .light
                self.isDarkMode = false
            case .dark:
                window?.overrideUserInterfaceStyle = .dark
                self.isDarkMode = true
            case .system:
                window?.overrideUserInterfaceStyle = .unspecified
                // Check system theme
                if let windowScene = windowScene {
                    self.isDarkMode = windowScene.windows.first?.traitCollection.userInterfaceStyle == .dark
                }
            }
        }
    }
}

