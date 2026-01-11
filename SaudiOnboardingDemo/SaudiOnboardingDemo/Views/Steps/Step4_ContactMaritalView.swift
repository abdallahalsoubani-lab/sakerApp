//
//  Step4_ContactMaritalView.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import SwiftUI

struct Step4_ContactMaritalView: View {
    @EnvironmentObject var registrationData: RegistrationData
    @State private var emailError: String? = nil
    @State private var spouseNameError: String? = nil
    @State private var passportError: String? = nil

    var isMarried: Bool {
        registrationData.maritalStatus == .married
    }

    var body: some View {
        ScrollView {
            VStack(spacing: AppConstants.spacing) {
                // Header
                Text("التواصل والحالة الاجتماعية")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Card
                VStack(spacing: AppConstants.spacing) {
                    CustomTextField(
                        title: "البريد الإلكتروني *",
                        text: $registrationData.email,
                        placeholder: "example@email.com",
                        keyboardType: .emailAddress,
                        errorMessage: emailError
                    )
                    .onChange(of: registrationData.email) { _, _ in
                        emailError = nil
                    }

                    CustomPicker(title: "المستوى التعليمي *", selection: $registrationData.educationLevel)

                    CustomPicker(title: "الحالة الاجتماعية *", selection: $registrationData.maritalStatus)

                    if isMarried {
                        CustomTextField(
                            title: "اسم الزوج/الزوجة *",
                            text: $registrationData.spouseName,
                            placeholder: "أدخل الاسم",
                            errorMessage: spouseNameError
                        )
                        .onChange(of: registrationData.spouseName) { _, _ in
                            spouseNameError = nil
                        }
                    }

                    Divider()

                    Text("بيانات الجواز (اختياري)")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    CustomTextField(
                        title: "رقم الجواز",
                        text: $registrationData.passportNumber,
                        placeholder: "A12345678",
                        errorMessage: passportError
                    )
                    .onChange(of: registrationData.passportNumber) { _, _ in
                        passportError = nil
                    }

                    CustomDatePicker(
                        title: "تاريخ إصدار الجواز",
                        selection: Binding(
                            get: { registrationData.passportIssueDate ?? Date() },
                            set: { registrationData.passportIssueDate = $0 }
                        ),
                        displayedComponents: .date
                    )

                    CustomDatePicker(
                        title: "تاريخ انتهاء الجواز",
                        selection: Binding(
                            get: { registrationData.passportExpiryDate ?? Date() },
                            set: { registrationData.passportExpiryDate = $0 }
                        ),
                        displayedComponents: .date
                    )
                }
                .padding()
                .background(AppColors.cardBackground)
                .cornerRadius(AppConstants.cornerRadius)
                .shadow(color: Color.black.opacity(0.05), radius: 5)

                Spacer()

                // Navigation
                HStack(spacing: 16) {
                    CustomButton(title: "رجوع", action: {
                        registrationData.currentStep = 3
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
        // Validate Email
        if !ValidationService.shared.isValidEmail(registrationData.email) {
            emailError = ValidationMessages.emailError
            return
        }

        // Validate Spouse Name if married
        if isMarried && registrationData.spouseName.isEmpty {
            spouseNameError = ValidationMessages.spouseNameError
            return
        }

        // Validate Passport if provided
        if !registrationData.passportNumber.isEmpty && !ValidationService.shared.isValidPassport(registrationData.passportNumber) {
            passportError = ValidationMessages.passportError
            return
        }

        registrationData.currentStep = 5
    }
}

#Preview {
    Step4_ContactMaritalView()
        .environmentObject(RegistrationData())
}
