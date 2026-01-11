//
//  Transaction.swift
//  SaudiOnboardingDemo
//
//  Created on 2026-01-11
//

import Foundation

// MARK: - Transaction Type
enum TransactionType {
    case topUp
    case investment
    case dividend
    case withdrawal
    
    var iconName: String {
        switch self {
        case .topUp: return "arrow.down.left"
        case .investment: return "arrow.up.right"
        case .dividend: return "banknote"
        case .withdrawal: return "arrow.up.right"
        }
    }
    
    var iconBackground: String {
        switch self {
        case .topUp: return "lightGray"
        case .investment: return "black"
        case .dividend: return "orange"
        case .withdrawal: return "lightGray"
        }
    }
}

// MARK: - Transaction Status
enum TransactionStatus: String {
    case completed = "Completed"
    case processing = "Processing"
    case pending = "Pending"
    case failed = "Failed"
}

// MARK: - Transaction Model
struct Transaction: Identifiable {
    let id: UUID
    let title: String
    let subtitle: String
    let amount: Double
    let date: Date
    let type: TransactionType
    let status: TransactionStatus
    
    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        amount: Double,
        date: Date,
        type: TransactionType,
        status: TransactionStatus
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.amount = amount
        self.date = date
        self.type = type
        self.status = status
    }
    
    var formattedAmount: String {
        let prefix = amount >= 0 ? "+" : "-"
        return "\(prefix) \(String(format: "%.0f", abs(amount))) SAR"
    }
    
    var amountColor: String {
        return amount >= 0 ? "orange" : "primary"
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            formatter.dateFormat = "'Today,' h:mm a"
        } else if calendar.isDateInYesterday(date) {
            formatter.dateFormat = "'Yesterday,' h:mm a"
        } else {
            formatter.dateFormat = "MMM d, yyyy"
        }
        
        return formatter.string(from: date)
    }
}

// MARK: - Mock Data
extension Transaction {
    static var mockTransactions: [Transaction] {
        let now = Date()
        let calendar = Calendar.current
        
        return [
            Transaction(
                title: "Top Up via Apple Pay",
                subtitle: "",
                amount: 5000,
                date: now,
                type: .topUp,
                status: .completed
            ),
            Transaction(
                title: "Investment: Riyadh Logistics",
                subtitle: "",
                amount: -25000,
                date: calendar.date(byAdding: .day, value: -1, to: now)!,
                type: .investment,
                status: .completed
            ),
            Transaction(
                title: "Dividend Payment (Q4)",
                subtitle: "",
                amount: 1250,
                date: calendar.date(byAdding: .day, value: -7, to: now)!,
                type: .dividend,
                status: .completed
            ),
            Transaction(
                title: "Withdrawal to SABB Bank",
                subtitle: "",
                amount: -10000,
                date: calendar.date(byAdding: .day, value: -8, to: now)!,
                type: .withdrawal,
                status: .processing
            )
        ]
    }
}
