//
//  Step8_LoginCredentialsView.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import SwiftUI

struct Step8_LoginCredentialsView: View {
    @EnvironmentObject var registrationData: RegistrationData
    @State private var usernameError: String? = nil
    @State private var passwordError: String? = nil
    @State private var confirmPasswordError: String? = nil
    @State private var isSubmitting = false

    var body: some View {
        ScrollView {
            VStack(spacing: ResponsiveLayout.baseSpacing) {
                // Header
                VStack(alignment: .leading, spacing: ResponsiveLayout.smallSpacing) {
                    Text("بيانات الدخول")
                        .font(.system(size: ResponsiveLayout.titleSize, weight: .bold))
                        .foregroundColor(AppColors.primary)
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)

                    Text("آخر خطوة! قم بإنشاء بيانات تسجيل الدخول")
                        .font(.system(size: ResponsiveLayout.bodySize))
                        .foregroundColor(AppColors.textSecondary)
                        .minimumScaleFactor(0.9)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Card
                VStack(spacing: ResponsiveLayout.baseSpacing) {
                    CustomTextField(
                        title: "اسم المستخدم *",
                        text: $registrationData.username,
                        placeholder: "username123",
                        errorMessage: usernameError
                    )
                    .onChange(of: registrationData.username) { _, _ in
                        usernameError = nil
                    }

                    Text("6-20 حرف/رقم، يمكن استخدام . و _")
                        .font(.system(size: ResponsiveLayout.captionSize))
                        .foregroundColor(AppColors.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .minimumScaleFactor(0.8)
                        .lineLimit(2)

                    CustomSecureField(
                        title: "كلمة المرور *",
                        text: $registrationData.password,
                        placeholder: "********",
                        errorMessage: passwordError
                    )
                    .onChange(of: registrationData.password) { _, _ in
                        passwordError = nil
                    }

                    Text("8 أحرف على الأقل، حرف كبير، حرف صغير، رقم، ورمز خاص")
                        .font(.system(size: ResponsiveLayout.captionSize))
                        .foregroundColor(AppColors.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .minimumScaleFactor(0.8)
                        .lineLimit(2)

                    CustomSecureField(
                        title: "تأكيد كلمة المرور *",
                        text: $registrationData.confirmPassword,
                        placeholder: "********",
                        errorMessage: confirmPasswordError
                    )
                    .onChange(of: registrationData.confirmPassword) { _, _ in
                        confirmPasswordError = nil
                    }
                }
                .responsiveCardStyle()

                Spacer()

                if isSubmitting {
                    ProgressView("جاري إرسال البيانات...")
                        .padding(ResponsiveLayout.baseSpacing)
                }

                // Navigation
                HStack(spacing: ResponsiveLayout.baseSpacing) {
                    CustomButton(title: "رجوع", action: {
                        registrationData.currentStep = 7
                    }, isPrimary: false)

                    CustomButton(title: "إرسال ✅") {
                        validateAndSubmit()
                    }
                    .disabled(isSubmitting)
                }
            }
            .responsivePadding()
            .padding(.vertical, ResponsiveLayout.verticalPadding)
        }
        .background(AppColors.background.ignoresSafeArea())
    }

    private func validateAndSubmit() {
        // Validate Username
        if !ValidationService.shared.isValidUsername(registrationData.username) {
            usernameError = ValidationMessages.usernameError
            return
        }

        // Validate Password
        if !ValidationService.shared.isValidPassword(registrationData.password) {
            passwordError = ValidationMessages.passwordError
            return
        }

        // Validate Password Match
        if registrationData.password != registrationData.confirmPassword {
            confirmPasswordError = ValidationMessages.passwordMatchError
            return
        }

        // Submit (Demo)
        isSubmitting = true

        Task {
            // Simulate API call
            try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds

            await MainActor.run {
                isSubmitting = false
                // Move to success page
                registrationData.currentStep = 9
            }
        }
    }
}

#Preview {
    Step8_LoginCredentialsView()
        .environmentObject(RegistrationData())
}
