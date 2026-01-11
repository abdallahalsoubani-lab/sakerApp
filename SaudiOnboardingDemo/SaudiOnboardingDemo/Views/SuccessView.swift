//
//  SuccessView.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import SwiftUI

struct SuccessView: View {
    @EnvironmentObject var registrationData: RegistrationData

    var body: some View {
        ScrollView {
            VStack(spacing: AppConstants.spacing) {
                // Success Icon
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 100))
                    .foregroundColor(AppColors.success)
                    .padding(.top, 50)

                Text("تم التسجيل بنجاح! 🎉")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.primary)

                Text("تم إرسال بياناتك بنجاح. سيتم مراجعتها والتواصل معك قريباً.")
                    .font(.body)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding()

                // Summary Card
                VStack(alignment: .leading, spacing: AppConstants.spacing) {
                    Text("ملخص البيانات")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(AppColors.primary)

                    Divider()

                    SummarySection(title: "معلومات الاتصال") {
                        SummaryRow(label: "رقم الجوال", value: registrationData.phoneNumber)
                        SummaryRow(label: "البريد الإلكتروني", value: registrationData.email)
                    }

                    SummarySection(title: "المعلومات الشخصية") {
                        SummaryRow(label: "الاسم بالعربي", value: registrationData.fullNameArabic)
                        SummaryRow(label: "الاسم بالإنجليزي", value: registrationData.fullNameEnglish)
                        SummaryRow(label: "رقم الهوية", value: registrationData.nationalId)
                        SummaryRow(label: "الجنسية", value: registrationData.nationality.rawValue)
                    }

                    SummarySection(title: "معلومات العمل") {
                        SummaryRow(label: "المهنة", value: registrationData.profession.rawValue)
                        SummaryRow(label: "جهة العمل", value: registrationData.employerName)
                        SummaryRow(label: "الدخل الشهري", value: "\(registrationData.monthlyIncome) \(registrationData.currency.rawValue)")
                    }

                    SummarySection(title: "العنوان") {
                        SummaryRow(label: "المدينة", value: registrationData.city.rawValue)
                        SummaryRow(label: "الحي", value: registrationData.district)
                        SummaryRow(label: "الرمز البريدي", value: registrationData.postalCode)
                    }

                    SummarySection(title: "بيانات الحساب") {
                        SummaryRow(label: "نوع الحساب", value: registrationData.accountType.rawValue)
                        SummaryRow(label: "العملة", value: registrationData.accountCurrency.rawValue)
                        SummaryRow(label: "الفرع", value: registrationData.branch.rawValue)
                    }

                    SummarySection(title: "بيانات الدخول") {
                        SummaryRow(label: "اسم المستخدم", value: registrationData.username)
                    }
                }
                .padding()
                .background(AppColors.cardBackground)
                .cornerRadius(AppConstants.cornerRadius)
                .shadow(color: Color.black.opacity(0.05), radius: 5)

                Spacer()

                CustomButton(title: "إنهاء") {
                    registrationData.reset()
                }
                .padding(.top)
            }
            .padding()
        }
        .background(AppColors.background.ignoresSafeArea())
    }
}

struct SummarySection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.primary)

            content()
        }
    }
}

struct SummaryRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundColor(AppColors.textSecondary)
            Spacer()
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(AppColors.textPrimary)
        }
    }
}

#Preview {
    SuccessView()
        .environmentObject(RegistrationData())
}
