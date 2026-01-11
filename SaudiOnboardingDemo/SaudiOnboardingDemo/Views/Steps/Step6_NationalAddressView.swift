//
//  Step6_NationalAddressView.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import SwiftUI

struct Step6_NationalAddressView: View {
    @EnvironmentObject var registrationData: RegistrationData
    @State private var buildingNumberError: String? = nil
    @State private var streetNameError: String? = nil
    @State private var districtError: String? = nil
    @State private var postalCodeError: String? = nil
    @State private var additionalNumberError: String? = nil
    @State private var unitNumberError: String? = nil
    @State private var showMap = false

    var body: some View {
        ScrollView {
            VStack(spacing: AppConstants.spacing) {
                // Header
                Text("العنوان الوطني السعودي")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Card
                VStack(spacing: AppConstants.spacing) {
                    CustomTextField(
                        title: "رقم المبنى *",
                        text: $registrationData.buildingNumber,
                        placeholder: "1234",
                        keyboardType: .numberPad,
                        errorMessage: buildingNumberError
                    )
                    .onChange(of: registrationData.buildingNumber) { _, _ in
                        buildingNumberError = nil
                    }

                    CustomTextField(
                        title: "اسم الشارع *",
                        text: $registrationData.streetName,
                        placeholder: "شارع الملك فهد",
                        errorMessage: streetNameError
                    )
                    .onChange(of: registrationData.streetName) { _, _ in
                        streetNameError = nil
                    }

                    CustomTextField(
                        title: "الحي/المنطقة *",
                        text: $registrationData.district,
                        placeholder: "حي العليا",
                        errorMessage: districtError
                    )
                    .onChange(of: registrationData.district) { _, _ in
                        districtError = nil
                    }

                    CustomPicker(title: "المدينة *", selection: $registrationData.city)

                    CustomTextField(
                        title: "الرمز البريدي *",
                        text: $registrationData.postalCode,
                        placeholder: "12345",
                        keyboardType: .numberPad,
                        errorMessage: postalCodeError
                    )
                    .onChange(of: registrationData.postalCode) { _, _ in
                        postalCodeError = nil
                    }

                    CustomTextField(
                        title: "الرقم الإضافي *",
                        text: $registrationData.additionalNumber,
                        placeholder: "5678",
                        keyboardType: .numberPad,
                        errorMessage: additionalNumberError
                    )
                    .onChange(of: registrationData.additionalNumber) { _, _ in
                        additionalNumberError = nil
                    }

                    CustomTextField(
                        title: "رقم الوحدة (اختياري)",
                        text: $registrationData.unitNumber,
                        placeholder: "123",
                        keyboardType: .numberPad,
                        errorMessage: unitNumberError
                    )
                    .onChange(of: registrationData.unitNumber) { _, _ in
                        unitNumberError = nil
                    }

                    // Map Button
                    CustomButton(title: "📍 تحديد موقع المنزل على الخريطة", action: {
                        showMap = true
                    }, isPrimary: false)

                    if registrationData.homeLocation != nil {
                        InfoBadge(text: "تم تحديد الموقع ✅")
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
                        registrationData.currentStep = 5
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
                MapView(coordinate: $registrationData.homeLocation)
                    .navigationTitle("موقع المنزل")
                    .navigationBarItems(trailing: Button("إغلاق") {
                        showMap = false
                    })
            }
        }
    }

    private func validateAndNext() {
        // Validate Building Number
        if !ValidationService.shared.isValidBuildingNumber(registrationData.buildingNumber) {
            buildingNumberError = ValidationMessages.buildingNumberError
            return
        }

        // Validate Street Name
        if registrationData.streetName.isEmpty {
            streetNameError = ValidationMessages.streetNameError
            return
        }

        // Validate District
        if registrationData.district.isEmpty {
            districtError = ValidationMessages.districtError
            return
        }

        // Validate Postal Code
        if !ValidationService.shared.isValidPostalCode(registrationData.postalCode) {
            postalCodeError = ValidationMessages.postalCodeError
            return
        }

        // Validate Additional Number
        if !ValidationService.shared.isValidAdditionalNumber(registrationData.additionalNumber) {
            additionalNumberError = ValidationMessages.additionalNumberError
            return
        }

        // Validate Unit Number if provided
        if !registrationData.unitNumber.isEmpty && !ValidationService.shared.isValidUnitNumber(registrationData.unitNumber) {
            unitNumberError = ValidationMessages.unitNumberError
            return
        }

        registrationData.currentStep = 7
    }
}

#Preview {
    Step6_NationalAddressView()
        .environmentObject(RegistrationData())
}
