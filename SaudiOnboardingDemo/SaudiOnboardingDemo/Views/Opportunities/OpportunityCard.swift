//
//  OpportunityCard.swift
//  SaudiOnboardingDemo
//
//  Created on 2026-01-11
//

import SwiftUI

// MARK: - Opportunity Card
struct OpportunityCard: View {
    
    // MARK: - Properties
    let opportunity: InvestmentOpportunity
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image with overlay
            imageSection
            
            // Investment Details
            detailsSection
        }
        .background(Color(UIColor.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
    
    // MARK: - Image Section
    private var imageSection: some View {
        ZStack(alignment: .topLeading) {
            // Background Image
            Image(opportunity.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 180)
                .clipped()
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.black.opacity(0.4),
                            Color.black.opacity(0.1),
                            Color.clear
                        ]),
                        startPoint: .bottom,
                        endPoint: .center
                    )
                )
            
            // Type Tag and Coming Soon Badge
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    // Type Badge
                    Text(opportunity.type.tagName)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.primary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(
                            Color.white
                                .cornerRadius(8)
                        )
                    
                    // Coming Soon Badge
                    if opportunity.status == .comingSoon {
                        Text("COMING SOON")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(
                                Color.gray.opacity(0.9)
                                    .cornerRadius(8)
                            )
                    }
                }
                
                Spacer()
                
                // Title and Location
                VStack(alignment: .leading, spacing: 6) {
                    Text(opportunity.title)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.4), radius: 3, x: 0, y: 2)
                    
                    HStack(spacing: 5) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 13))
                        Text(opportunity.location)
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.4), radius: 3, x: 0, y: 2)
                }
            }
            .padding(16)
        }
        .frame(height: 180)
        .cornerRadius(20, corners: [.topLeft, .topRight])
    }
    
    // MARK: - Details Section
    private var detailsSection: some View {
        VStack(spacing: 20) {
            // Stats Row
            statsRow
            
            // Funding Progress
            fundingProgress
        }
        .padding(20)
    }
    
    // MARK: - Stats Row
    private var statsRow: some View {
        HStack(spacing: 0) {
            // Return
            VStack(alignment: .leading, spacing: 6) {
                Text("RETURN")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.secondary)
                    .tracking(0.5)
                
                Text(String(format: "%.1f%%", opportunity.returnRate))
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color.orange)
            }
            
            Spacer()
            
            // Yield
            VStack(alignment: .center, spacing: 6) {
                Text("YIELD")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.secondary)
                    .tracking(0.5)
                
                Text(String(format: "%.2f%%", opportunity.yieldRate))
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            // Min Investment
            VStack(alignment: .trailing, spacing: 6) {
                Text("MIN INV")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.secondary)
                    .tracking(0.5)
                
                Text(String(opportunity.minInvestment))
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.primary)
            }
        }
    }
    
    // MARK: - Funding Progress
    private var fundingProgress: some View {
        VStack(spacing: 10) {
            if opportunity.status == .comingSoon {
                // Coming Soon Message
                Text("Opens for funding in \(opportunity.comingSoonDays ?? 0) days")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 4)
            } else {
                // Progress Bar and Info
                HStack(spacing: 0) {
                    Text("Funded: \(Int(opportunity.fundedPercentage))%")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("Target: \(String(format: "%.1fM", opportunity.targetAmount))")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.primary)
                }
                
                // Progress Bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Background
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.gray.opacity(0.15))
                            .frame(height: 6)
                        
                        // Progress
                        RoundedRectangle(cornerRadius: 3)
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
                                height: 6
                            )
                    }
                }
                .frame(height: 6)
            }
        }
    }
}

// MARK: - Rounded Corners Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Preview
struct OpportunityCard_Previews: PreviewProvider {
    static var previews: some View {
        OpportunityCard(opportunity: InvestmentOpportunity.mockData[0])
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
