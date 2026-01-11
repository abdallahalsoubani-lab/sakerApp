//
//  CustomButton.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import SwiftUI

struct CustomButton: View {
    let title: String
    let action: () -> Void
    var isPrimary: Bool = true
    var isDisabled: Bool = false

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    isDisabled ? Color.gray : (isPrimary ? AppColors.primary : AppColors.secondary)
                )
                .cornerRadius(AppConstants.cornerRadius)
        }
        .disabled(isDisabled)
    }
}

#Preview {
    VStack(spacing: 16) {
        CustomButton(title: "التالي", action: {})
        CustomButton(title: "رجوع", action: {}, isPrimary: false)
        CustomButton(title: "معطل", action: {}, isDisabled: true)
    }
    .padding()
}
