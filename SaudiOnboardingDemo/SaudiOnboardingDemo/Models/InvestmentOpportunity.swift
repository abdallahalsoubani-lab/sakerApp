//
//  InvestmentOpportunity.swift
//  SaudiOnboardingDemo
//
//  Created on 2026-01-11
//

import Foundation

// MARK: - Property Type Enum
enum PropertyType: String, CaseIterable, Identifiable {
    case all = "All"
    case residential = "Residential"
    case commercial = "Commercial"
    case industrial = "Industrial"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        return rawValue
    }
    
    var tagName: String {
        return rawValue.uppercased()
    }
}

// MARK: - Investment Status
enum InvestmentStatus: String {
    case active = "Active"
    case comingSoon = "Coming Soon"
    case funded = "Funded"
}

// MARK: - Investment Opportunity Model
struct InvestmentOpportunity: Identifiable {
    let id: UUID
    let title: String
    let location: String
    let type: PropertyType
    let imageName: String
    let returnRate: Double
    let yieldRate: Double
    let minInvestment: Int
    let fundedPercentage: Double
    let targetAmount: Double
    let status: InvestmentStatus
    let comingSoonDays: Int?
    
    init(
        id: UUID = UUID(),
        title: String,
        location: String,
        type: PropertyType,
        imageName: String,
        returnRate: Double,
        yieldRate: Double,
        minInvestment: Int,
        fundedPercentage: Double,
        targetAmount: Double,
        status: InvestmentStatus = .active,
        comingSoonDays: Int? = nil
    ) {
        self.id = id
        self.title = title
        self.location = location
        self.type = type
        self.imageName = imageName
        self.returnRate = returnRate
        self.yieldRate = yieldRate
        self.minInvestment = minInvestment
        self.fundedPercentage = fundedPercentage
        self.targetAmount = targetAmount
        self.status = status
        self.comingSoonDays = comingSoonDays
    }
}

// MARK: - Mock Data
extension InvestmentOpportunity {
    static var mockData: [InvestmentOpportunity] {
        return [
            InvestmentOpportunity(
                title: "Riyadh Logistics Center 04",
                location: "Industrial Zone 2, Riyadh",
                type: .industrial,
                imageName: "construction_site",
                returnRate: 8.66,
                yieldRate: 7.36,
                minInvestment: 2500,
                fundedPercentage: 28,
                targetAmount: 40.0
            ),
            InvestmentOpportunity(
                title: "Jeddah Corniche Heights",
                location: "North Corniche, Jeddah",
                type: .residential,
                imageName: "jeddah_aerial",
                returnRate: 6.2,
                yieldRate: 5.27,
                minInvestment: 5000,
                fundedPercentage: 65,
                targetAmount: 25.0
            ),
            InvestmentOpportunity(
                title: "Downtown Dubai Offices",
                location: "Business Bay, Dubai",
                type: .commercial,
                imageName: "dubai_offices",
                returnRate: 7.1,
                yieldRate: 6.03,
                minInvestment: 2000,
                fundedPercentage: 12,
                targetAmount: 60.0
            ),
            InvestmentOpportunity(
                title: "Dammam Warehousing Complex",
                location: "Dammam Port, KSA",
                type: .industrial,
                imageName: "warehouse_industrial",
                returnRate: 9.15,
                yieldRate: 7.78,
                minInvestment: 2500,
                fundedPercentage: 0,
                targetAmount: 35.0,
                status: .comingSoon,
                comingSoonDays: 2
            )
        ]
    }
}
