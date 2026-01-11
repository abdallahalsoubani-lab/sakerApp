//
//  SaudiOnboardingDemoApp.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import SwiftUI
import Foundation
import Combine

@main
struct SaudiOnboardingDemoApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
    }
}

// MARK: - Root Tab View
struct RootTabView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        Group {
            switch selectedTab {
            case 0:
                OpportunitiesView()
            case 1:
                WalletView()
            case 2:
                ProfilePlaceholderView()
            default:
                OpportunitiesView()
            }
        }
        .safeAreaInset(edge: .bottom) {
            BottomNavigationBar(selectedTab: $selectedTab)
        }
    }
}

// MARK: - Transaction Type
enum TransactionType {
    case topUp, investment, dividend, withdrawal
    
    var iconName: String {
        switch self {
        case .topUp: return "arrow.down.left"
        case .investment: return "arrow.up.right"
        case .dividend: return "banknote"
        case .withdrawal: return "arrow.up.right"
        }
    }
}

// MARK: - Transaction Status
enum TransactionStatus: String {
    case completed = "Completed"
    case processing = "Processing"
}

// MARK: - Transaction Model
struct Transaction: Identifiable {
    let id = UUID()
    let title: String
    let amount: Double
    let date: Date
    let type: TransactionType
    let status: TransactionStatus
    
    var formattedAmount: String {
        let prefix = amount >= 0 ? "+" : "-"
        return "\(prefix) \(String(format: "%.0f", abs(amount))) SAR"
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

// MARK: - Wallet ViewModel
class WalletViewModel: ObservableObject {
    @Published var totalBalance: Double = 124500.00
    @Published var availableToInvest: Double = 24500.00
    @Published var totalInvested: Double = 100000.00
    @Published var transactions: [Transaction] = []
    
    init() {
        loadWalletData()
    }
    
    func loadWalletData() {
        let now = Date()
        let calendar = Calendar.current
        
        transactions = [
            Transaction(
                title: "Top Up via Apple Pay",
                amount: 5000,
                date: now,
                type: .topUp,
                status: .completed
            ),
            Transaction(
                title: "Investment: Riyadh Logistics",
                amount: -25000,
                date: calendar.date(byAdding: .day, value: -1, to: now)!,
                type: .investment,
                status: .completed
            ),
            Transaction(
                title: "Dividend Payment (Q4)",
                amount: 1250,
                date: calendar.date(byAdding: .day, value: -7, to: now)!,
                type: .dividend,
                status: .completed
            ),
            Transaction(
                title: "Withdrawal to SABB Bank",
                amount: -10000,
                date: calendar.date(byAdding: .day, value: -8, to: now)!,
                type: .withdrawal,
                status: .processing
            )
        ]
    }
    
    func topUp() { print("Top Up") }
    func withdraw() { print("Withdraw") }
}

// MARK: - Wallet View
struct WalletView: View {
    @StateObject private var viewModel = WalletViewModel()
    private let gutter: CGFloat = 20
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                headerSection
                balanceCard
                statsCards
                transactionsSection
            }
            .padding(.horizontal, gutter)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    private var headerSection: some View {
        HStack {
            Text("Wallet")
                .font(.system(size: 32, weight: .bold))
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 22))
                    .foregroundColor(.primary)
            }
        }
    }
    
    private var balanceCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Total Balance")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(String(format: "%.2f", viewModel.totalBalance))
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                    Text("SAR")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            HStack(spacing: 12) {
                Button(action: viewModel.topUp) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .bold))
                        Text("Top Up")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [Color(red: 0.85, green: 0.75, blue: 0.45), Color(red: 0.75, green: 0.65, blue: 0.35)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(12)
                }
                
                Button(action: viewModel.withdraw) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.down.left")
                            .font(.system(size: 16, weight: .bold))
                        Text("Withdraw")
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(white: 0.25))
                    .cornerRadius(12)
                }
            }
        }
        .padding(24)
        .background(
            LinearGradient(
                colors: [Color(white: 0.15), Color(white: 0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 8)
    }
    
    private var statsCards: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Available to Invest")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
                Text("\(String(format: "%.0f", viewModel.availableToInvest)) SAR")
                    .font(.system(size: 22, weight: .bold))
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Total Invested")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
                Text("\(String(format: "%.0f", viewModel.totalInvested)) SAR")
                    .font(.system(size: 22, weight: .bold))
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }
    
    private var transactionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Transactions")
                .font(.system(size: 22, weight: .bold))
            
            VStack(spacing: 0) {
                ForEach(viewModel.transactions) { transaction in
                    TransactionRow(transaction: transaction)
                    if transaction.id != viewModel.transactions.last?.id {
                        Divider().padding(.leading, 60)
                    }
                }
            }
            .background(Color(UIColor.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }
}

// MARK: - Transaction Row
struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(iconBackgroundColor)
                    .frame(width: 44, height: 44)
                Image(systemName: transaction.type.iconName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .font(.system(size: 15, weight: .semibold))
                Text(transaction.formattedDate)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(transaction.formattedAmount)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(transaction.amount >= 0 ? .orange : .primary)
                Text(transaction.status.rawValue)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
    
    private var iconBackgroundColor: Color {
        switch transaction.type {
        case .topUp: return Color(UIColor.systemGray5)
        case .investment: return Color.black
        case .dividend: return Color.orange.opacity(0.15)
        case .withdrawal: return Color(UIColor.systemGray5)
        }
    }
    
    private var iconColor: Color {
        switch transaction.type {
        case .topUp: return .primary
        case .investment: return .white
        case .dividend: return .orange
        case .withdrawal: return .primary
        }
    }
}

// MARK: - Profile View
struct ProfilePlaceholderView: View {
    private let gutter: CGFloat = 20
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Profile Header
                profileHeader
                
                // Account Verified Banner
                verifiedBanner
                
                // Account Settings
                settingsSection(
                    title: "ACCOUNT SETTINGS",
                    items: [
                        ("person", "Personal Information", nil),
                        ("bell", "Notifications", nil),
                        ("globe", "Language", "English"),
                        ("gearshape", "Preferences", nil)
                    ]
                )
                
                // Financial
                settingsSection(
                    title: "FINANCIAL",
                    items: [
                        ("creditcard", "Payment Methods", nil),
                        ("doc.text", "Documents & Statements", nil),
                        ("doc.text", "Tax Reports", nil)
                    ]
                )
                
                // Support & Legal
                settingsSection(
                    title: "SUPPORT & LEGAL",
                    items: [
                        ("questionmark.circle", "Help Center", nil),
                        ("doc.text", "Terms & Conditions", nil),
                        ("doc.text", "Privacy Policy", nil)
                    ]
                )
                
                // Log Out Button
                logOutButton
            }
            .padding(.horizontal, gutter)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    private var profileHeader: some View {
        VStack(spacing: 16) {
            // Profile Image
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color(UIColor.systemGray5))
                    .frame(width: 100, height: 100)
                
                // Verified Badge
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color(red: 0.85, green: 0.75, blue: 0.45))
                }
                .offset(x: 4, y: 4)
            }
            
            // Name and Email
            VStack(spacing: 6) {
                Text("Faisal Al-Saud")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                
                HStack(spacing: 8) {
                    Text("faisal@example.com")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    
                    Text("ACCREDITED")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(red: 0.65, green: 0.55, blue: 0.25))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(red: 0.95, green: 0.90, blue: 0.70))
                        .cornerRadius(4)
                }
            }
        }
        .padding(.vertical, 20)
    }
    
    private var verifiedBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.shield.fill")
                .font(.system(size: 24))
                .foregroundColor(Color(red: 0.85, green: 0.75, blue: 0.45))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Account Verified")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Your KYC is complete and up to date.")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color(red: 1.0, green: 0.98, blue: 0.88))
        .cornerRadius(12)
    }
    
    private func settingsSection(title: String, items: [(icon: String, title: String, trailing: String?)]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary)
                .tracking(0.5)
            
            VStack(spacing: 0) {
                ForEach(items.indices, id: \.self) { index in
                    settingsRow(
                        icon: items[index].icon,
                        title: items[index].title,
                        trailing: items[index].trailing
                    )
                    
                    if index < items.count - 1 {
                        Divider()
                            .padding(.leading, 44)
                    }
                }
            }
            .background(Color(UIColor.systemBackground))
            .cornerRadius(12)
        }
    }
    
    private func settingsRow(icon: String, title: String, trailing: String?) -> some View {
        Button(action: {}) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.primary)
                    .frame(width: 24)
                
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.primary)
                
                Spacer()
                
                if let trailing = trailing {
                    Text(trailing)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
    }
    
    private var logOutButton: some View {
        Button(action: {}) {
            HStack(spacing: 8) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 18, weight: .semibold))
                
                Text("Log Out")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.red)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
        }
        .padding(.top, 20)
    }
}
