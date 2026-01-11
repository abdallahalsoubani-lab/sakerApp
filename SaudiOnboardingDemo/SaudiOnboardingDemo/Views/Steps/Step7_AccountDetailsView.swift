//
//  Step7_AccountDetailsView.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import SwiftUI

struct Step7_AccountDetailsView: View {
    @EnvironmentObject var registrationData: RegistrationData
    @State private var ibanError: String? = nil

    var needsDeliveryAddress: Bool {
        registrationData.deliveryLocation == .other
    }

    var body: some View {
        ScrollView {
            VStack(spacing: AppConstants.spacing) {
                // Header
                Text("بيانات الحساب والتوصيل")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(AppColors.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Card
                VStack(spacing: AppConstants.spacing) {
                    CustomPicker(title: "نوع الحساب *", selection: $registrationData.accountType)

                    CustomPicker(title: "العملة *", selection: $registrationData.accountCurrency)

                    CustomPicker(title: "الفرع *", selection: $registrationData.branch)

                    Divider()

                    Text("توصيل بطاقة ATM")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    CustomPicker(title: "توصيل إلى *", selection: $registrationData.deliveryLocation)

                    if needsDeliveryAddress {
                        DeliveryAddressSection(
                            buildingNumber: $registrationData.deliveryBuildingNumber,
                            streetName: $registrationData.deliveryStreetName,
                            district: $registrationData.deliveryDistrict,
                            city: $registrationData.deliveryCity,
                            postalCode: $registrationData.deliveryPostalCode,
                            additionalNumber: $registrationData.deliveryAdditionalNumber
                        )
                    }

                    Divider()

                    Toggle("استخدام IBAN (اختياري)", isOn: $registrationData.useIban)
                        .toggleStyle(SwitchToggleStyle(tint: AppColors.primary))

                    if registrationData.useIban {
                        CustomTextField(
                            title: "IBAN السعودي *",
                            text: $registrationData.iban,
                            placeholder: "SA0000000000000000000000",
                            errorMessage: ibanError
                        )
                        .onChange(of: registrationData.iban) { _, _ in
                            ibanError = nil
                        }
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
                        registrationData.currentStep = 6
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
        // Validate IBAN if enabled
        if registrationData.useIban && !ValidationService.shared.isValidIban(registrationData.iban) {
            ibanError = ValidationMessages.ibanError
            return
        }

        registrationData.currentStep = 8
    }
}

struct DeliveryAddressSection: View {
    @Binding var buildingNumber: String
    @Binding var streetName: String
    @Binding var district: String
    @Binding var city: City
    @Binding var postalCode: String
    @Binding var additionalNumber: String

    var body: some View {
        VStack(spacing: AppConstants.spacing) {
            Text("عنوان التوصيل")
                .font(.headline)
                .foregroundColor(AppColors.primary)
                .frame(maxWidth: .infinity, alignment: .leading)

            CustomTextField(title: "رقم المبنى *", text: $buildingNumber, placeholder: "1234", keyboardType: .numberPad)
            CustomTextField(title: "اسم الشارع *", text: $streetName, placeholder: "شارع الملك فهد")
            CustomTextField(title: "الحي *", text: $district, placeholder: "حي العليا")
            CustomPicker(title: "المدينة *", selection: $city)
            CustomTextField(title: "الرمز البريدي *", text: $postalCode, placeholder: "12345", keyboardType: .numberPad)
            CustomTextField(title: "الرقم الإضافي *", text: $additionalNumber, placeholder: "5678", keyboardType: .numberPad)
        }
    }
}

#Preview {
    Step7_AccountDetailsView()
        .environmentObject(RegistrationData())
}
