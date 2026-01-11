//
//  Step3_NamesView.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import SwiftUI

struct Step3_NamesView: View {
    @EnvironmentObject var registrationData: RegistrationData
    @State private var arabicNameError: String? = nil
    @State private var englishNameError: String? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: AppConstants.spacing) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("بيانات الأسماء")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.primary)

                    Text("تم تعبئة البيانات من الهوية تلقائياً")
                        .font(.body)
                        .foregroundColor(AppColors.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Card
                VStack(spacing: AppConstants.spacing) {
                    CustomTextField(
                        title: "الاسم الكامل بالعربي *",
                        text: $registrationData.fullNameArabic,
                        placeholder: "محمد بن عبدالله",
                        errorMessage: arabicNameError,
                        isDisabled: registrationData.isArabicNameFromOCR
                    )
                    .onChange(of: registrationData.fullNameArabic) { _, _ in
                        arabicNameError = nil
                    }

                    if registrationData.isArabicNameFromOCR {
                        InfoBadge(text: "تم التعبئة من الهوية ✅")
                    }

                    CustomTextField(
                        title: "الاسم الكامل بالإنجليزي *",
                        text: $registrationData.fullNameEnglish,
                        placeholder: "Mohammed Abdullah",
                        errorMessage: englishNameError,
                        isDisabled: registrationData.isEnglishNameFromOCR
                    )
                    .onChange(of: registrationData.fullNameEnglish) { _, _ in
                        englishNameError = nil
                    }

                    if registrationData.isEnglishNameFromOCR {
                        InfoBadge(text: "تم التعبئة من الهوية ✅")
                    }
                }
                .padding()
                .background(AppColors.cardBackground)
                .cornerRadius(AppConstants.cornerRadius)
                .shadow(color: Color.black.opacity(0.05), radius: 5)

                Spacer()

                // Navigation
                HStack(spacing: 16) {
                    CustomButton(title: "رجوع", action: {
                        registrationData.currentStep = 2
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
        // Validate Arabic Name
        if registrationData.fullNameArabic.isEmpty || !ValidationService.shared.isValidArabicName(registrationData.fullNameArabic) {
            arabicNameError = ValidationMessages.arabicNameError
            return
        }

        // Validate English Name
        if registrationData.fullNameEnglish.isEmpty || !ValidationService.shared.isValidEnglishName(registrationData.fullNameEnglish) {
            englishNameError = ValidationMessages.englishNameError
            return
        }

        registrationData.currentStep = 4
    }
}

struct InfoBadge: View {
    let text: String

    var body: some View {
        HStack {
            Image(systemName: "info.circle.fill")
            Text(text)
                .font(.caption)
        }
        .foregroundColor(AppColors.success)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(AppColors.success.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    Step3_NamesView()
        .environmentObject(RegistrationData())
}
