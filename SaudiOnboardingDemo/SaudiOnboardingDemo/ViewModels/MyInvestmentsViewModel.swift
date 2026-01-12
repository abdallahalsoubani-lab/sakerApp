//
//  MyInvestmentsViewModel.swift
//  SaudiOnboardingDemo
//
//  Created on 2026-01-12
//

import Foundation
import Combine

// MARK: - My Investments ViewModel
class MyInvestmentsViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var myInvestments: [MyInvestment] = []
    @Published var isLoading: Bool = false
    
    // MARK: - Computed Properties
    var totalInvestment: Double {
        myInvestments.reduce(0) { $0 + $1.investedAmount }
    }
    
    var currentValue: Double {
        myInvestments.reduce(0) { $0 + $1.currentValue }
    }
    
    var totalReturn: Double {
        currentValue - totalInvestment
    }
    
    var totalReturnPercentage: Double {
        guard totalInvestment > 0 else { return 0 }
        return (totalReturn / totalInvestment) * 100
    }
    
    var totalFunds: Int {
        myInvestments.count
    }
    
    var profitDistributions: Int {
        2 // Mock value
    }
    
    // MARK: - Initialization
    init() {
        loadInvestments()
    }
    
    // MARK: - Public Methods
    func loadInvestments() {
        isLoading = true
        
        // Simulate API call with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.myInvestments = MyInvestment.mockData
            self?.isLoading = false
        }
    }
}
