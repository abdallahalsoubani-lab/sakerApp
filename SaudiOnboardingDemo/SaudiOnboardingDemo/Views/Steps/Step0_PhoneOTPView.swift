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
            VStack(spacing: ResponsiveLayout.baseSpacing) {
                // Header
                VStack(alignment: .leading, spacing: ResponsiveLayout.smallSpacing) {
                    Text("مرحباً بك")
                        .font(.system(size: ResponsiveLayout.largeTitleSize, weight: .bold))
                        .foregroundColor(AppColors.primary)
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)

                    Text("الرجاء إدخال رقم الجوال للمتابعة")
                        .font(.system(size: ResponsiveLayout.bodySize))
                        .foregroundColor(AppColors.textSecondary)
                        .minimumScaleFactor(0.9)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, ResponsiveLayout.smallSpacing)

                // Card
                VStack(spacing: ResponsiveLayout.baseSpacing) {
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
                        VStack(alignment: .leading, spacing: ResponsiveLayout.baseSpacing) {
                            HStack(spacing: ResponsiveLayout.smallSpacing) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(AppColors.success)
                                    .font(.system(size: ResponsiveLayout.bodySize))
                                Text("تم إرسال رمز التحقق إلى \(registrationData.phoneNumber)")
                                    .font(.system(size: ResponsiveLayout.captionSize))
                                    .foregroundColor(AppColors.textSecondary)
                                    .minimumScaleFactor(0.8)
                                    .lineLimit(2)
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
                                .font(.system(size: ResponsiveLayout.captionSize, weight: .semibold))
                                .foregroundColor(AppColors.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Button("إعادة إرسال الرمز") {
                                sendOTP()
                            }
                            .font(.system(size: ResponsiveLayout.captionSize))
                            .foregroundColor(AppColors.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .responsiveCardStyle()

                Spacer()

                // Next Button
                CustomButton(title: "التالي") {
                    validateAndNext()
                }
                .disabled(!otpSent)
            }
            .responsivePadding()
            .padding(.vertical, ResponsiveLayout.verticalPadding)
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
