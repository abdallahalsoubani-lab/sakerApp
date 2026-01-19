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
        switch self {
        case .all:
            return LocalizedStrings.get("property.all")
        case .residential:
            return LocalizedStrings.get("property.residential")
        case .commercial:
            return LocalizedStrings.get("property.commercial")
        case .industrial:
            return LocalizedStrings.get("property.industrial")
        }
    }
    
    var tagName: String {
        return displayName.uppercased()
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
                title: LocalizedStrings.get("opportunity.logisticsPark"),
                location: LocalizedStrings.get("opportunity.logisticsParkLocation"),
                type: .industrial,
                imageName: "construction_site",
                returnRate: 8.66,
                yieldRate: 7.36,
                minInvestment: 2500,
                fundedPercentage: 28,
                targetAmount: 40.0
            ),
            InvestmentOpportunity(
                title: LocalizedStrings.get("opportunity.riyadhFront"),
                location: LocalizedStrings.get("opportunity.riyadhFrontLocation"),
                type: .commercial,
                imageName: "jeddah_aerial",
                returnRate: 6.2,
                yieldRate: 5.27,
                minInvestment: 5000,
                fundedPercentage: 65,
                targetAmount: 25.0
            ),
            InvestmentOpportunity(
                title: LocalizedStrings.get("opportunity.laysenValley"),
                location: LocalizedStrings.get("opportunity.laysenValleyLocation"),
                type: .residential,
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
