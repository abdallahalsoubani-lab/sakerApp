//
//  TimelineItem.swift
//  SaudiOnboardingDemo
//
//  Created on 2026-01-11
//

import Foundation

// MARK: - Timeline Status
enum TimelineStatus {
    case completed
    case current
    case upcoming
}

// MARK: - Timeline Item
struct TimelineItem: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    let description: String
    let status: TimelineStatus
}

// MARK: - Document Item
struct DocumentItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
}

// MARK: - Mock Data
extension TimelineItem {
    static var mockTimeline: [TimelineItem] {
        return [
            TimelineItem(
                title: "Fundraising Period",
                date: "Nov 2025 - Dec 2025",
                description: "Initial capital raising phase.",
                status: .completed
            ),
            TimelineItem(
                title: "Property Acquisition",
                date: "Jan 15, 2026",
                description: "Asset transfer and registration.",
                status: .current
            ),
            TimelineItem(
                title: "First Dividend",
                date: "Feb 28, 2026",
                description: "Expected first monthly payout.",
                status: .upcoming
            ),
            TimelineItem(
                title: "Exit Strategy",
                date: "Q4 2030",
                description: "Projected sale or refinancing.",
                status: .upcoming
            )
        ]
    }
}

extension DocumentItem {
    static var mockDocuments: [DocumentItem] {
        return [
            DocumentItem(title: "Fund Memo EN", icon: "doc.text"),
            DocumentItem(title: "Executive Summary", icon: "doc.text"),
            DocumentItem(title: "Shariah Certificate", icon: "doc.text"),
            DocumentItem(title: "Valuation Report", icon: "doc.text")
        ]
    }
}
