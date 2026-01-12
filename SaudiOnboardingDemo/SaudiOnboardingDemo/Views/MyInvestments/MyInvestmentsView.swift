//
//  MyInvestmentsView.swift
//  SaudiOnboardingDemo
//
//  Created on 2026-01-12
//

import SwiftUI

// MARK: - My Investments View
struct MyInvestmentsView: View {
    @StateObject private var viewModel = MyInvestmentsViewModel()
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.colorScheme) var colorScheme
    private let gutter: CGFloat = 20
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                headerSection
                statsOverviewCard
                statsCards
                currentInvestmentsSection
            }
            .padding(.horizontal, gutter)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedStrings.get("myInvestments.title"))
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "chart.bar.xaxis")
                    .font(.system(size: 22))
                    .foregroundColor(.primary)
            }
        }
    }
    
    // MARK: - Stats Overview Card
    private var statsOverviewCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text(LocalizedStrings.get("myInvestments.totalInvestment"))
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                
                CurrencyText(
                    amount: String(format: "%.0f", viewModel.totalInvestment),
                    amountSize: 48,
                    logoSize: 36,
                    color: .white,
                    weight: .bold
                )
            }
            
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(LocalizedStrings.get("myInvestments.currentValue"))
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    CurrencyText(
                        amount: String(format: "%.0f", viewModel.currentValue),
                        amountSize: 22,
                        logoSize: 18,
                        color: .white,
                        weight: .bold
                    )
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 6) {
                    Text(LocalizedStrings.get("myInvestments.totalReturn"))
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    HStack(spacing: 6) {
                        Text(String(format: "+%.1f%%", viewModel.totalReturnPercentage))
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(Color(red: 0.85, green: 0.75, blue: 0.45))
                        
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(red: 0.85, green: 0.75, blue: 0.45))
                    }
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
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(colorScheme == .dark ? 0.1 : 0), lineWidth: 1)
        )
        .shadow(
            color: colorScheme == .dark ? Color.white.opacity(0.15) : Color.black.opacity(0.15),
            radius: 20,
            x: 0,
            y: 8
        )
    }
    
    // MARK: - Stats Cards
    private var statsCards: some View {
        HStack(spacing: 16) {
            statCard(
                icon: "building.2",
                iconColor: .orange,
                title: LocalizedStrings.get("myInvestments.stats.funds"),
                value: "\(viewModel.totalFunds)"
            )
            
            statCard(
                icon: "calendar",
                iconColor: .orange,
                title: LocalizedStrings.get("myInvestments.stats.distributions"),
                value: "\(viewModel.profitDistributions)"
            )
            
            statCard(
                icon: "chart.line.uptrend.xyaxis",
                iconColor: Color(red: 0.85, green: 0.75, blue: 0.45),
                title: LocalizedStrings.get("myInvestments.stats.return"),
                value: String(format: "%.1fK", viewModel.totalReturn / 1000)
            )
        }
    }
    
    private func statCard(icon: String, iconColor: Color, title: String, value: String) -> some View {
        VStack(alignment: .center, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(iconColor)
            
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)
            
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(colorScheme == .dark ? 0.3 : 0.1), lineWidth: 1)
        )
        .shadow(
            color: colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.05),
            radius: 8,
            x: 0,
            y: 2
        )
    }
    
    // MARK: - Current Investments Section
    private var currentInvestmentsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(LocalizedStrings.get("myInvestments.currentInvestments"))
                .font(.system(size: 22, weight: .bold))
            
            VStack(spacing: 16) {
                ForEach(viewModel.myInvestments) { investment in
                    InvestmentCard(investment: investment)
                }
            }
        }
    }
}

// MARK: - Investment Card
struct InvestmentCard: View {
    let investment: MyInvestment
    @Environment(\.colorScheme) var colorScheme
    private let gutter: CGFloat = 16
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image Section
            ZStack(alignment: .topLeading) {
                Image(investment.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 180)
                    .clipped()
                
                // Location Badge
                HStack(spacing: 6) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 12))
                    Text(investment.location)
                        .font(.system(size: 12, weight: .medium))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.black.opacity(0.6))
                .cornerRadius(20)
                .padding(12)
            }
            
            // Content Section
            VStack(alignment: .leading, spacing: 16) {
                // Title
                Text(investment.title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                // Stats Row
                HStack(spacing: 20) {
                    statItem(
                        label: LocalizedStrings.get("myInvestments.invested"),
                        amount: investment.investedAmount
                    )
                    
                    statItem(
                        label: LocalizedStrings.get("myInvestments.currentValue"),
                        amount: investment.currentValue
                    )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(LocalizedStrings.get("myInvestments.expectedReturn"))
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.secondary)
                            .tracking(0.5)
                        
                        Text(String(format: "%.2f%%", investment.returnPercentage))
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(red: 0.85, green: 0.75, blue: 0.45))
                    }
                }
                
                // Progress Bar
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(String(format: "%.0f%%", investment.progressPercentage))
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.primary)
                        
                        Text(LocalizedStrings.get("myInvestments.progress"))
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color(UIColor.systemGray5))
                                .frame(height: 8)
                                .cornerRadius(4)
                            
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.orange, Color.orange.opacity(0.7)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geometry.size.width * (investment.progressPercentage / 100), height: 8)
                                .cornerRadius(4)
                        }
                    }
                    .frame(height: 8)
                }
                
                // View Details Button
                Button(action: {}) {
                    HStack {
                        Text(LocalizedStrings.get("myInvestments.viewDetails"))
                            .font(.system(size: 15, weight: .semibold))
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundColor(.primary)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 16)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                }
            }
            .padding(gutter)
        }
        .background(Color(UIColor.systemBackground))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(colorScheme == .dark ? 0.3 : 0.1), lineWidth: 1)
        )
        .shadow(
            color: colorScheme == .dark ? Color.white.opacity(0.15) : Color.black.opacity(0.08),
            radius: 12,
            x: 0,
            y: 4
        )
    }
    
    private func statItem(label: String, amount: Double) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.secondary)
                .tracking(0.5)
            
            CurrencyText(
                amount: String(format: "%.0f", amount),
                amountSize: 16,
                logoSize: 14,
                color: .primary,
                weight: .bold
            )
        }
    }
}

// MARK: - Preview
struct MyInvestmentsView_Previews: PreviewProvider {
    static var previews: some View {
        MyInvestmentsView()
            .environmentObject(LocalizationManager.shared)
            .environmentObject(ThemeManager.shared)
    }
}
