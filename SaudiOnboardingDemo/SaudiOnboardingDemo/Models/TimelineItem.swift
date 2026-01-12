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
                title: LocalizedStrings.get("timeline.fundraising"),
                date: "Nov 2025 - Dec 2025",
                description: LocalizedStrings.get("timeline.fundraisingDesc"),
                status: .completed
            ),
            TimelineItem(
                title: LocalizedStrings.get("timeline.acquisition"),
                date: "Jan 15, 2026",
                description: LocalizedStrings.get("timeline.acquisitionDesc"),
                status: .current
            ),
            TimelineItem(
                title: LocalizedStrings.get("timeline.firstDividend"),
                date: "Feb 28, 2026",
                description: LocalizedStrings.get("timeline.firstDividendDesc"),
                status: .upcoming
            ),
            TimelineItem(
                title: LocalizedStrings.get("timeline.exitStrategy"),
                date: "Q4 2030",
                description: LocalizedStrings.get("timeline.exitStrategyDesc"),
                status: .upcoming
            )
        ]
    }
}

extension DocumentItem {
    static var mockDocuments: [DocumentItem] {
        return [
            DocumentItem(title: LocalizedStrings.get("doc.fundMemo"), icon: "doc.text"),
            DocumentItem(title: LocalizedStrings.get("doc.executiveSummary"), icon: "doc.text"),
            DocumentItem(title: LocalizedStrings.get("doc.shariahCert"), icon: "doc.text"),
            DocumentItem(title: LocalizedStrings.get("doc.valuationReport"), icon: "doc.text")
        ]
    }
}
