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
        VStack(spacing: 8) {
            HStack {
                Text("الخطوة \(currentStep) من \(totalSteps)")
                    .font(.subheadline)
                    .foregroundColor(AppColors.textSecondary)

                Spacer()

                Text("\(Int(progress * 100))%")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.primary)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                        .cornerRadius(4)

                    // Progress
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [AppColors.primary, AppColors.secondary]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * progress, height: 8)
                        .cornerRadius(4)
                        .animation(.spring(), value: progress)
                }
            }
            .frame(height: 8)
        }
        .padding()
        .background(Color.white)
        .shadow(color: Color.black.opacity(0.05), radius: 2, y: 2)
    }
}

#Preview {
    ProgressBar(currentStep: 3)
}
