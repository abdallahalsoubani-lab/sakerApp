//
//  ContentView.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import SwiftUI

struct ContentView: View {
    @StateObject private var registrationData = RegistrationData()

    var body: some View {
        VStack(spacing: 0) {
            // Progress Bar (Status Bar في الأعلى)
            if registrationData.currentStep < 9 {
                ProgressBar(currentStep: registrationData.currentStep)
            }

            // Step Content
            Group {
                switch registrationData.currentStep {
                case 0:
                    Step0_PhoneOTPView()
                case 1:
                    Step1_KYCBasicView()
                case 2:
                    Step2_IDScanOCRView()
                case 3:
                    Step3_NamesView()
                case 4:
                    Step4_ContactMaritalView()
                case 5:
                    Step5_JobIncomeView()
                case 6:
                    Step6_NationalAddressView()
                case 7:
                    Step7_AccountDetailsView()
                case 8:
                    Step8_LoginCredentialsView()
                case 9:
                    SuccessView()
                default:
                    Text("خطوة غير معروفة")
                }
            }
            .environmentObject(registrationData)
        }
        .preferredColorScheme(.light)
        .onTapGesture {
            hideKeyboard()
        }
    }
}

#Preview {
    ContentView()
}
