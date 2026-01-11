//
//  WalletViewModel.swift
//  SaudiOnboardingDemo
//
//  Created on 2026-01-11
//

import Foundation
import Combine

// MARK: - Wallet ViewModel
class WalletViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var totalBalance: Double = 124500.00
    @Published var availableToInvest: Double = 24500.00
    @Published var totalInvested: Double = 100000.00
    @Published var transactions: [Transaction] = []
    @Published var isLoading: Bool = false
    
    // MARK: - Initialization
    init() {
        loadWalletData()
    }
    
    // MARK: - Public Methods
    func loadWalletData() {
        isLoading = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.transactions = Transaction.mockTransactions
            self?.isLoading = false
        }
    }
    
    func refreshData() {
        loadWalletData()
    }
    
    func topUp() {
        // Handle top up action
        print("Top Up tapped")
    }
    
    func withdraw() {
        // Handle withdraw action
        print("Withdraw tapped")
    }
}
