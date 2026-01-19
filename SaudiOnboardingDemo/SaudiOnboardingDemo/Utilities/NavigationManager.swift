//
//  NavigationManager.swift
//  SaudiOnboardingDemo
//
//  Created on 2026-01-13
//

import Foundation
import SwiftUI

// MARK: - Navigation Manager
class NavigationManager: ObservableObject {
    static let shared = NavigationManager()
    
    @Published var shouldReturnToLaunch: Bool = false
    
    private init() {}
    
    func returnToLaunchScreen() {
        shouldReturnToLaunch = true
    }
    
    func resetNavigation() {
        shouldReturnToLaunch = false
    }
}
