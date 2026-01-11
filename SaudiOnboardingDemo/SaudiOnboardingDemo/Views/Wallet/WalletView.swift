//
//  WalletView.swift
//  SaudiOnboardingDemo
//
//  Created on 2026-01-11
//

import SwiftUI

// MARK: - Wallet View
struct WalletView: View {
    
    // MARK: - Properties
    @StateObject private var viewModel = WalletViewModel()
    
    // MARK: - Constants
    private let gutter: CGFloat = 20
    
    // MARK: - Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Header
                headerSection
                
                // Balance Card
                balanceCard
                
                // Stats Cards
                statsCards
                
                // Recent Transactions
                transactionsSection
            }
            .padding(.horizontal, gutter)
            .padding(.top, 16)
            .padding(.bottom, 24)
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            Text("Wallet")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.primary)
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 22))
                    .foregroundColor(.primary)
                    .frame(width: 44, height: 44)
            }
        }
    }
    
    // MARK: - Balance Card
    private var balanceCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Total Balance
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
            
            // Action Buttons
            HStack(spacing: 12) {
                // Top Up Button
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
                            gradient: Gradient(colors: [
                                Color(red: 0.85, green: 0.75, blue: 0.45),
                                Color(red: 0.75, green: 0.65, blue: 0.35)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(12)
                }
                
                // Withdraw Button
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
                gradient: Gradient(colors: [
                    Color(white: 0.15),
                    Color(white: 0.1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 8)
    }
    
    // MARK: - Stats Cards
    private var statsCards: some View {
        HStack(spacing: 16) {
            // Available to Invest
            VStack(alignment: .leading, spacing: 8) {
                Text("Available to Invest")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
                
                Text("\(String(format: "%.0f", viewModel.availableToInvest)) SAR")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.primary)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
            
            // Total Invested
            VStack(alignment: .leading, spacing: 8) {
                Text("Total Invested")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
                
                Text("\(String(format: "%.0f", viewModel.totalInvested)) SAR")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.primary)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }
    
    // MARK: - Transactions Section
    private var transactionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Transactions")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.primary)
            
            VStack(spacing: 0) {
                ForEach(viewModel.transactions) { transaction in
                    TransactionRow(transaction: transaction)
                    
                    if transaction.id != viewModel.transactions.last?.id {
                        Divider()
                            .padding(.leading, 60)
                    }
                }
            }
            .background(Color(UIColor.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }
}

// MARK: - Transaction Row
struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(iconBackgroundColor)
                    .frame(width: 44, height: 44)
                
                Image(systemName: transaction.type.iconName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(iconColor)
            }
            
            // Title and Date
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(transaction.formattedDate)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Amount and Status
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
        case .topUp:
            return Color(UIColor.systemGray5)
        case .investment:
            return Color.black
        case .dividend:
            return Color.orange.opacity(0.15)
        case .withdrawal:
            return Color(UIColor.systemGray5)
        }
    }
    
    private var iconColor: Color {
        switch transaction.type {
        case .topUp:
            return .primary
        case .investment:
            return .white
        case .dividend:
            return .orange
        case .withdrawal:
            return .primary
        }
    }
}

// MARK: - Preview
struct WalletView_Previews: PreviewProvider {
    static var previews: some View {
        WalletView()
    }
}
