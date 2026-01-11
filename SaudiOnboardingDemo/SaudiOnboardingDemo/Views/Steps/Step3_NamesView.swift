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
            VStack(spacing: ResponsiveLayout.baseSpacing) {
                // Header
                VStack(alignment: .leading, spacing: ResponsiveLayout.smallSpacing) {
                    Text("بيانات الأسماء")
                        .font(.system(size: ResponsiveLayout.titleSize, weight: .bold))
                        .foregroundColor(AppColors.primary)
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)

                    Text("تم تعبئة البيانات من الهوية تلقائياً")
                        .font(.system(size: ResponsiveLayout.bodySize))
                        .foregroundColor(AppColors.textSecondary)
                        .minimumScaleFactor(0.9)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Card
                VStack(spacing: ResponsiveLayout.baseSpacing) {
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
                .responsiveCardStyle()

                Spacer()

                // Navigation
                HStack(spacing: ResponsiveLayout.baseSpacing) {
                    CustomButton(title: "رجوع", action: {
                        registrationData.currentStep = 2
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
        HStack(spacing: ResponsiveLayout.smallSpacing) {
            Image(systemName: "info.circle.fill")
                .font(.system(size: ResponsiveLayout.captionSize))
            Text(text)
                .font(.system(size: ResponsiveLayout.captionSize))
                .minimumScaleFactor(0.8)
                .lineLimit(1)
        }
        .foregroundColor(AppColors.success)
        .padding(.horizontal, ResponsiveLayout.cardPadding)
        .padding(.vertical, ResponsiveLayout.smallSpacing)
        .background(AppColors.success.opacity(0.1))
        .cornerRadius(ResponsiveLayout.cornerRadius)
    }
}

#Preview {
    Step3_NamesView()
        .environmentObject(RegistrationData())
}
