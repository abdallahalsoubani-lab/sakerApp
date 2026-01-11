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
            VStack(spacing: AppConstants.spacing) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("بيانات الدخول")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.primary)

                    Text("آخر خطوة! قم بإنشاء بيانات تسجيل الدخول")
                        .font(.body)
                        .foregroundColor(AppColors.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Card
                VStack(spacing: AppConstants.spacing) {
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
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)

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
                        .font(.caption)
                        .foregroundColor(AppColors.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)

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
                .padding()
                .background(AppColors.cardBackground)
                .cornerRadius(AppConstants.cornerRadius)
                .shadow(color: Color.black.opacity(0.05), radius: 5)

                Spacer()

                if isSubmitting {
                    ProgressView("جاري إرسال البيانات...")
                        .padding()
                }

                // Navigation
                HStack(spacing: 16) {
                    CustomButton(title: "رجوع", action: {
                        registrationData.currentStep = 7
                    }, isPrimary: false)

                    CustomButton(title: "إرسال ✅") {
                        validateAndSubmit()
                    }
                    .disabled(isSubmitting)
                }
            }
            .padding()
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
