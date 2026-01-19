//
//  ProgressBar.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import SwiftUI

struct ProgressBar: View {
    let currentStep: Int
    let totalSteps: Int = AppConstants.totalSteps

    var progress: Double {
        return Double(currentStep) / Double(totalSteps)
    }

    var body: some View {
        VStack(spacing: ResponsiveLayout.smallSpacing) {
            HStack {
                Text("الخطوة \(currentStep) من \(totalSteps)")
                    .font(.system(size: ResponsiveLayout.bodySize))
                    .foregroundColor(AppColors.textSecondary)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)

                Spacer()

                Text("\(Int(progress * 100))%")
                    .font(.system(size: ResponsiveLayout.bodySize, weight: .semibold))
                    .foregroundColor(AppColors.primary)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    Rectangle()
                        .fill(Color(UIColor.systemGray5))
                        .frame(height: ResponsiveLayout.smallSpacing)
                        .cornerRadius(ResponsiveLayout.smallSpacing / 2)

                    // Progress
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [AppColors.primary, AppColors.secondary]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress, height: ResponsiveLayout.smallSpacing)
                        .cornerRadius(ResponsiveLayout.smallSpacing / 2)
                        .animation(.spring(), value: progress)
                }
            }
            .frame(height: ResponsiveLayout.smallSpacing)
        }
        .responsivePadding()
        .padding(.vertical, ResponsiveLayout.baseSpacing)
        .background(Color(UIColor.systemBackground))
        .shadow(color: Color.primary.opacity(0.1), radius: 2, y: 2)
    }
}

#Preview {
    ProgressBar(currentStep: 3)
}
