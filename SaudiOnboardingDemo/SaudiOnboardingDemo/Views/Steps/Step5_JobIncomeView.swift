//
//  Step5_JobIncomeView.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import SwiftUI

struct Step5_JobIncomeView: View {
    @EnvironmentObject var registrationData: RegistrationData
    @State private var incomeError: String? = nil
    @State private var employerNameError: String? = nil
    @State private var workIdError: String? = nil
    @State private var showMap = false

    var body: some View {
        ScrollView {
            VStack(spacing: AppConstants.spacing) {
                // Header
                Text("الوظيفة والدخل")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Card
                VStack(spacing: AppConstants.spacing) {
                    CustomPicker(title: "المهنة *", selection: $registrationData.profession)

                    CustomTextField(
                        title: "الدخل الشهري *",
                        text: $registrationData.monthlyIncome,
                        placeholder: "5000.00",
                        keyboardType: .decimalPad,
                        errorMessage: incomeError
                    )
                    .onChange(of: registrationData.monthlyIncome) { _, _ in
                        incomeError = nil
                    }

                    CustomPicker(title: "العملة *", selection: $registrationData.currency)

                    CustomTextField(
                        title: "اسم جهة العمل *",
                        text: $registrationData.employerName,
                        placeholder: "اسم الشركة",
                        errorMessage: employerNameError
                    )
                    .onChange(of: registrationData.employerName) { _, _ in
                        employerNameError = nil
                    }

                    CustomPicker(title: "مدينة العمل *", selection: $registrationData.workCity)

                    // Map Button
                    CustomButton(title: "📍 تحديد موقع العمل على الخريطة", action: {
                        showMap = true
                    }, isPrimary: false)

                    if registrationData.workLocation != nil {
                        InfoBadge(text: "تم تحديد الموقع ✅")
                    }

                    CustomTextField(
                        title: "رقم تعريف العمل (Work ID) *",
                        text: $registrationData.workId,
                        placeholder: "WID-12345",
                        errorMessage: workIdError
                    )
                    .onChange(of: registrationData.workId) { _, _ in
                        workIdError = nil
                    }

                    CustomDatePicker(
                        title: "تاريخ انتهاء هوية العمل",
                        selection: Binding(
                            get: { registrationData.workIdExpiryDate ?? Date() },
                            set: { registrationData.workIdExpiryDate = $0 }
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
                        registrationData.currentStep = 4
                    }, isPrimary: false)

                    CustomButton(title: "التالي") {
                        validateAndNext()
                    }
                }
            }
            .padding()
        }
        .background(AppColors.background.ignoresSafeArea())
        .sheet(isPresented: $showMap) {
            NavigationView {
                MapView(coordinate: $registrationData.workLocation)
                    .navigationTitle("موقع العمل")
                    .navigationBarItems(trailing: Button("إغلاق") {
                        showMap = false
                    })
            }
        }
    }

    private func validateAndNext() {
        // Validate Income
        if !ValidationService.shared.isValidIncome(registrationData.monthlyIncome) {
            incomeError = ValidationMessages.incomeError
            return
        }

        // Validate Employer Name
        if registrationData.employerName.isEmpty {
            employerNameError = ValidationMessages.employerNameError
            return
        }

        // Validate Work ID
        if !ValidationService.shared.isValidWorkId(registrationData.workId) {
            workIdError = ValidationMessages.workIdError
            return
        }

        registrationData.currentStep = 6
    }
}

#Preview {
    Step5_JobIncomeView()
        .environmentObject(RegistrationData())
}
