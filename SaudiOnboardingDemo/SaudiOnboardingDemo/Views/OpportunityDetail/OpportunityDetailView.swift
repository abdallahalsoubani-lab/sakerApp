//
//  OpportunityDetailView.swift
//  SaudiOnboardingDemo
//
//  Created on 2026-01-11
//

import SwiftUI

// MARK: - Opportunity Detail View
struct OpportunityDetailView: View {
    
    // MARK: - Properties
    let opportunity: InvestmentOpportunity
    @Binding var hideTabBar: Bool
    @Environment(\.presentationMode) var presentationMode
    @State private var investmentAmount: Double = 26000
    @State private var showingCalculator = false
    
    // MARK: - Computed Properties
    private var projectedValue: Double {
        investmentAmount * (1 + opportunity.returnRate / 100)
    }
    
    private var annualIncome: Double {
        investmentAmount * (opportunity.yieldRate / 100)
    }
    
    private var appreciation: Double {
        projectedValue - investmentAmount
    }
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Hero Image Section (Edge-to-Edge from top)
                        heroSection
                            .frame(width: geometry.size.width)
                        
                        // Content Sections
                        VStack(spacing: DesignConstants.sectionSpacing) {
                            statsSection
                            fundingProgressSection
                            viewersSection
                            calculatorCard
                            timelineSection
                            dueDiligenceSection
                            documentsSection
                        }
                        .frame(maxWidth: geometry.size.width)
                        .contentPadding()
                        .padding(.top, DesignConstants.sectionSpacing)
                        .padding(.bottom, 100)
                    }
                    .frame(maxWidth: geometry.size.width)
                }
                .ignoresSafeArea(edges: .top)
                
                // Custom Navigation Bar
                customNavBar
                    .frame(width: geometry.size.width)
            }
            .navigationBarHidden(true)
            .safeAreaInset(edge: .bottom) {
                bottomActionBar
                    .frame(width: geometry.size.width)
            }
        }
        .onAppear {
            hideTabBar = true
        }
        .onDisappear {
            hideTabBar = false
        }
    }
    
    // MARK: - Hero Section (Edge-to-Edge)
    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            // Background Image (Full Width - Edge to Edge)
            Image(opportunity.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 380)
                .clipped()
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.black.opacity(0.6),
                            Color.black.opacity(0.3),
                            Color.clear
                        ]),
                        startPoint: .bottom,
                        endPoint: .center
                    )
                )
            
            // LIVE FUNDING Badge (With Gutter)
            if opportunity.status == .active {
                VStack {
                    HStack {
                        Spacer()
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 6, height: 6)
                            Text("LIVE FUNDING")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.primary)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white.cornerRadius(16))
                    }
                    .padding(.trailing, 40)
                    Spacer()
                }
                .padding(.top, 60)
            }
            
            // Title and Location
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(opportunity.title)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack(spacing: 6) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 13))
                        Text(opportunity.location)
                            .font(.system(size: 13, weight: .medium))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 20)
        }
        .frame(height: 380)
    }
    
    // MARK: - Stats Section
    private var statsSection: some View {
        HStack(spacing: 0) {
            VStack(spacing: 8) {
                Text("ANNUAL RETURN")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.secondary)
                    .tracking(0.5)
                
                Text(String(format: "%.2f%%", opportunity.returnRate))
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.orange)
            }
            .frame(maxWidth: .infinity)
            
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 1, height: 50)
            
            VStack(spacing: 8) {
                Text("DISTRIBUTION")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.secondary)
                    .tracking(0.5)
                
                Text("Monthly")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 1, height: 50)
            
            VStack(spacing: 8) {
                Text("TERM")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.secondary)
                    .tracking(0.5)
                
                Text("5 Years")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 20)
    }
    
    // MARK: - Funding Progress Section
    private var fundingProgressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Funding Progress")
                    .font(.system(size: 20, weight: .bold))
                
                Spacer()
                
                Text("\(Int(100 - opportunity.fundedPercentage))% Available")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(Color.black.cornerRadius(14))
            }
            
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 12)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.orange.opacity(0.9),
                                    Color.orange
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(
                            width: geometry.size.width * CGFloat(opportunity.fundedPercentage / 100),
                            height: 12
                        )
                }
            }
            .frame(height: 12)
            
            HStack {
                Text("Funded: \(String(format: "%.1fM", opportunity.targetAmount * opportunity.fundedPercentage / 100)) SAR")
                    .font(.system(size: 12, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                
                Spacer(minLength: 8)
                
                Text("Target: \(String(format: "%.0f,000,000", opportunity.targetAmount)) SAR")
                    .font(.system(size: 12, weight: .semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .foregroundColor(.primary)
        }
    }
    
    // MARK: - Viewers Section
    private var viewersSection: some View {
        HStack(spacing: 12) {
            HStack(spacing: -8) {
                ForEach(0..<3) { _ in
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 32, height: 32)
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                }
            }
            
            HStack(spacing: 4) {
                Image(systemName: "eye")
                    .font(.system(size: 14))
                Text("241 investors viewed this today")
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding(16)
        .background(Color(UIColor.secondarySystemBackground).cornerRadius(16))
    }
    
    // MARK: - Calculator Card
    private var calculatorCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(String(format: "%.0f", projectedValue))
                    .font(.system(size: 36, weight: .bold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Text("SAR")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text("+\(String(format: "%.2f%%", opportunity.returnRate))")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.orange)
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.orange)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(Color.orange.opacity(0.1).cornerRadius(6))
            }
            
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Annual Income")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                    Text("\(String(format: "%.0f", annualIncome)) SAR")
                        .font(.system(size: 15, weight: .bold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Appreciation")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                    Text("\(String(format: "%.0f", appreciation)) SAR")
                        .font(.system(size: 15, weight: .bold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            HStack(spacing: 16) {
                Button(action: {
                    if investmentAmount > Double(opportunity.minInvestment) {
                        investmentAmount -= 1000
                    }
                }) {
                    Image(systemName: "minus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(width: 44, height: 44)
                        .background(Color(UIColor.systemGray6).cornerRadius(22))
                }
                
                HStack(spacing: 4) {
                    Text("\(String(format: "%.0f", investmentAmount))")
                        .font(.system(size: 18, weight: .bold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Text("SAR")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                
                Button(action: {
                    investmentAmount += 1000
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(width: 44, height: 44)
                        .background(Color(UIColor.systemGray6).cornerRadius(22))
                }
            }
            
            Slider(
                value: $investmentAmount,
                in: Double(opportunity.minInvestment)...100000,
                step: 1000
            )
            .accentColor(.orange)
        }
        .padding(18)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
    
    // MARK: - Timeline Section
    private var timelineSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Investment Timeline")
                .font(.system(size: 20, weight: .bold))
            
            ForEach(Array(TimelineItem.mockTimeline.enumerated()), id: \.element.id) { index, item in
                TimelineRow(item: item, isLast: index == TimelineItem.mockTimeline.count - 1)
            }
        }
    }
    
    // MARK: - Due Diligence Section
    private var dueDiligenceSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Due Diligence")
                .font(.system(size: 20, weight: .bold))
            
            HStack(spacing: 16) {
                VStack(spacing: 12) {
                    Image(systemName: "shield.checkerboard")
                        .font(.system(size: 36))
                        .foregroundColor(.primary)
                    
                    Text("CMA REGULATED")
                        .font(.system(size: 10, weight: .bold))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
                
                VStack(spacing: 12) {
                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.orange)
                    
                    Text("SHARIAH\nCOMPLIANT")
                        .font(.system(size: 10, weight: .bold))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
            }
            .frame(height: 120)
            
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black)
                        .frame(width: 54, height: 54)
                    
                    Text("AC")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Arch Capital")
                        .font(.system(size: 16, weight: .bold))
                    
                    Text("Established in 2020, a CMA-licensed investment firm specializing in industrial logistics assets across the GCC region.")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(16)
            .background(Color(UIColor.secondarySystemBackground).cornerRadius(16))
        }
    }
    
    // MARK: - Documents Section
    private var documentsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(DocumentItem.mockDocuments) { document in
                Button(action: {}) {
                    HStack(spacing: 14) {
                        Image(systemName: document.icon)
                            .font(.system(size: 20))
                            .foregroundColor(.secondary)
                            .frame(width: 24)
                        
                        Text(document.title)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 18)
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 1)
                }
            }
        }
    }
    
    // MARK: - Custom Nav Bar
    private var customNavBar: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.black.opacity(0.4))
                    .cornerRadius(20)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.black.opacity(0.4))
                    .cornerRadius(20)
            }
        }
        .padding(.leading, 40)
        .padding(.trailing, 40)
        .padding(.top, 16)
    }
    
    // MARK: - Bottom Action Bar
    private var bottomActionBar: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("MIN INVESTMENT")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.secondary)
                    .tracking(0.5)
                
                HStack(spacing: 4) {
                    Text("\(String(format: "%d", opportunity.minInvestment))")
                        .font(.system(size: 20, weight: .bold))
                        .lineLimit(1)
                    Text("SAR")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer(minLength: 8)
            
            Button(action: {}) {
                Text("Add to Cart")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 16)
                    .background(Color.black)
                    .cornerRadius(12)
            }
        }
        .padding(.horizontal, DesignConstants.horizontalGutter)
        .padding(.vertical, 16)
        .background(
            Color(UIColor.systemBackground)
                .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: -4)
        )
    }
}

// MARK: - Timeline Row
struct TimelineRow: View {
    let item: TimelineItem
    let isLast: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .stroke(iconColor, lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if item.status == .completed {
                        Circle()
                            .fill(iconColor)
                            .frame(width: 12, height: 12)
                    } else if item.status == .current {
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 12, height: 12)
                    }
                }
                
                if !isLast {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                }
            }
            .frame(width: 24, height: isLast ? 24 : nil)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(item.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    if item.status == .current {
                        Text("CURRENT")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.orange)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.orange.opacity(0.1).cornerRadius(4))
                    }
                }
                
                Text(item.date)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                
                Text(item.description)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .padding(.top, 2)
            }
            .padding(.bottom, isLast ? 0 : 20)
        }
    }
    
    private var iconColor: Color {
        switch item.status {
        case .completed: return .green
        case .current: return .orange
        case .upcoming: return .gray
        }
    }
}

// MARK: - Preview
struct OpportunityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        OpportunityDetailView(opportunity: InvestmentOpportunity.mockData[0], hideTabBar: .constant(true))
    }
}
