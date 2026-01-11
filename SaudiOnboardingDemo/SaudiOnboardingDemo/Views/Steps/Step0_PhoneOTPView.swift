//
//  Step0_PhoneOTPView.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import SwiftUI

struct Step0_PhoneOTPView: View {
    @EnvironmentObject var registrationData: RegistrationData
    @State private var phoneError: String? = nil
    @State private var otpError: String? = nil
    @State private var otpSent: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: AppConstants.spacing) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("مرحباً بك")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.primary)

                    Text("الرجاء إدخال رقم الجوال للمتابعة")
                        .font(.body)
                        .foregroundColor(AppColors.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom)

                // Card
                VStack(spacing: AppConstants.spacing) {
                    // Phone Number
                    CustomTextField(
                        title: "رقم الجوال السعودي *",
                        text: $registrationData.phoneNumber,
                        placeholder: "05xxxxxxxx",
                        keyboardType: .phonePad,
                        errorMessage: phoneError
                    )
                    .onChange(of: registrationData.phoneNumber) { _, _ in
                        phoneError = nil
                    }

                    // Send OTP Button
                    if !otpSent {
                        CustomButton(title: "إرسال رمز التحقق") {
                            sendOTP()
                        }
                    } else {
                        // OTP Section
                        VStack(alignment: .leading, spacing: AppConstants.spacing) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(AppColors.success)
                                Text("تم إرسال رمز التحقق إلى \(registrationData.phoneNumber)")
                                    .font(.caption)
                                    .foregroundColor(AppColors.textSecondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            CustomTextField(
                                title: "رمز التحقق (OTP) *",
                                text: $registrationData.otp,
                                placeholder: "123456",
                                keyboardType: .numberPad,
                                errorMessage: otpError
                            )
                            .onChange(of: registrationData.otp) { _, _ in
                                otpError = nil
                            }

                            Text("رمز التحقق للديمو: \(registrationData.generatedOtp)")
                                .font(.caption)
                                .foregroundColor(AppColors.primary)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Button("إعادة إرسال الرمز") {
                                sendOTP()
                            }
                            .font(.caption)
                            .foregroundColor(AppColors.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
                .background(AppColors.cardBackground)
                .cornerRadius(AppConstants.cornerRadius)
                .shadow(color: Color.black.opacity(0.05), radius: 5)

                Spacer()

                // Next Button
                CustomButton(title: "التالي") {
                    validateAndNext()
                }
                .disabled(!otpSent)
            }
            .padding()
        }
        .background(AppColors.background.ignoresSafeArea())
    }

    private func sendOTP() {
        // Validate phone
        if !ValidationService.shared.isValidSaudiPhone(registrationData.phoneNumber) {
            phoneError = ValidationMessages.phoneError
            return
        }

        // Generate OTP (Demo)
        registrationData.generatedOtp = String(format: "%06d", Int.random(in: 100000...999999))
        otpSent = true
    }

    private func validateAndNext() {
        // Validate OTP
        if !ValidationService.shared.isValidOtp(registrationData.otp) {
            otpError = ValidationMessages.otpError
            return
        }

        // Check if OTP matches
        if registrationData.otp != registrationData.generatedOtp {
            otpError = "رمز التحقق غير صحيح"
            return
        }

        // Mark as verified
        registrationData.isOtpVerified = true

        // Move to next step
        registrationData.currentStep = 1
    }
}

#Preview {
    Step0_PhoneOTPView()
        .environmentObject(RegistrationData())
}
