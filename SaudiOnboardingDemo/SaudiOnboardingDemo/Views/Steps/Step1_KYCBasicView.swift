//
//  Step1_KYCBasicView.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import SwiftUI

struct Step1_KYCBasicView: View {
    @EnvironmentObject var registrationData: RegistrationData
    @State private var nationalIdError: String? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: ResponsiveLayout.baseSpacing) {
                // Header
                VStack(alignment: .leading, spacing: ResponsiveLayout.smallSpacing) {
                    Text("بيانات KYC الأساسية")
                        .font(.system(size: ResponsiveLayout.titleSize, weight: .bold))
                        .foregroundColor(AppColors.primary)
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)

                    Text("الرجاء إدخال معلوماتك الأساسية")
                        .font(.system(size: ResponsiveLayout.bodySize))
                        .foregroundColor(AppColors.textSecondary)
                        .minimumScaleFactor(0.9)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Card
                VStack(spacing: ResponsiveLayout.baseSpacing) {
                    CustomPicker(title: "الجنسية *", selection: $registrationData.nationality)

                    CustomPicker(title: "حالة الإقامة *", selection: $registrationData.residencyStatus)

                    CustomTextField(
                        title: "رقم الهوية/الإقامة *",
                        text: $registrationData.nationalId,
                        placeholder: "1234567890",
                        keyboardType: .numberPad,
                        errorMessage: nationalIdError
                    )
                    .onChange(of: registrationData.nationalId) { _, _ in
                        nationalIdError = nil
                    }

                    CustomPicker(title: "هل أنت شخص سياسي (PEP)؟ *", selection: $registrationData.isPEP)

                    CustomPicker(title: "هل أنت المستفيد الحقيقي؟ *", selection: $registrationData.isBeneficialOwner)

                    CustomPicker(title: "هل أنت US Person (FATCA)؟ *", selection: $registrationData.isUSPerson)

                    CustomPicker(title: "قطاع العمل *", selection: $registrationData.workSector)
                }
                .responsiveCardStyle()

                Spacer()

                // Navigation Buttons
                HStack(spacing: ResponsiveLayout.baseSpacing) {
                    CustomButton(title: "رجوع", action: {
                        registrationData.currentStep = 0
                    }, isPrimary: false)

                    CustomButton(title: "التالي") {
                        validateAndNext()
                    }
                }
            }
            .responsivePadding()
            .padding(.vertical, ResponsiveLayout.verticalPadding)
        }
        .background(AppColors.background.ignoresSafeArea())
    }

    private func validateAndNext() {
        // Validate National ID
        if !ValidationService.shared.isValidNationalId(registrationData.nationalId) {
            nationalIdError = ValidationMessages.nationalIdError
            return
        }

        // Move to next step
        registrationData.currentStep = 2
    }
}

#Preview {
    Step1_KYCBasicView()
        .environmentObject(RegistrationData())
}
