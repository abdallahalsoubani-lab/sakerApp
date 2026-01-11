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
            VStack(spacing: AppConstants.spacing) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("بيانات KYC الأساسية")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.primary)

                    Text("الرجاء إدخال معلوماتك الأساسية")
                        .font(.body)
                        .foregroundColor(AppColors.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Card
                VStack(spacing: AppConstants.spacing) {
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
                .padding()
                .background(AppColors.cardBackground)
                .cornerRadius(AppConstants.cornerRadius)
                .shadow(color: Color.black.opacity(0.05), radius: 5)

                Spacer()

                // Navigation Buttons
                HStack(spacing: 16) {
                    CustomButton(title: "رجوع", action: {
                        registrationData.currentStep = 0
                    }, isPrimary: false)

                    CustomButton(title: "التالي") {
                        validateAndNext()
                    }
                }
            }
            .padding()
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
