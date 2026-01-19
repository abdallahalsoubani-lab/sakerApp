//
//  MyInvestment.swift
//  SaudiOnboardingDemo
//
//  Created on 2026-01-12
//

import Foundation

// MARK: - My Investment Model
struct MyInvestment: Identifiable {
    let id: UUID
    let title: String
    let location: String
    let imageName: String
    let investedAmount: Double
    let currentValue: Double
    let expectedReturn: Double
    let returnPercentage: Double
    let progressPercentage: Double
    let duration: String
    
    init(
        id: UUID = UUID(),
        title: String,
        location: String,
        imageName: String,
        investedAmount: Double,
        currentValue: Double,
        expectedReturn: Double,
        returnPercentage: Double,
        progressPercentage: Double,
        duration: String
    ) {
        self.id = id
        self.title = title
        self.location = location
        self.imageName = imageName
        self.investedAmount = investedAmount
        self.currentValue = currentValue
        self.expectedReturn = expectedReturn
        self.returnPercentage = returnPercentage
        self.progressPercentage = progressPercentage
        self.duration = duration
    }
    
    var profitAmount: Double {
        return currentValue - investedAmount
    }
}

// MARK: - Mock Data
extension MyInvestment {
    static var mockData: [MyInvestment] {
        return [
            MyInvestment(
                title: LocalizedStrings.get("opportunity.logisticsPark"),
                location: LocalizedStrings.get("opportunity.logisticsParkLocation"),
                imageName: "construction_site",
                investedAmount: 100000,
                currentValue: 175000,
                expectedReturn: 175000,
                returnPercentage: 75,
                progressPercentage: 20,
                duration: LocalizedStrings.get("myInvestments.months")
            ),
            MyInvestment(
                title: LocalizedStrings.get("opportunity.riyadhFront"),
                location: LocalizedStrings.get("opportunity.riyadhFrontLocation"),
                imageName: "jeddah_aerial",
                investedAmount: 150000,
                currentValue: 252375,
                expectedReturn: 252375,
                returnPercentage: 68.25,
                progressPercentage: 15,
                duration: LocalizedStrings.get("myInvestments.months")
            )
        ]
    }
}
