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
            VStack(spacing: ResponsiveLayout.baseSpacing) {
                // Header
                Text("بيانات الحساب والتوصيل")
                    .font(.system(size: ResponsiveLayout.titleSize, weight: .bold))
                    .foregroundColor(AppColors.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)

                // Card
                VStack(spacing: ResponsiveLayout.baseSpacing) {
                    CustomPicker(title: "نوع الحساب *", selection: $registrationData.accountType)

                    CustomPicker(title: "العملة *", selection: $registrationData.accountCurrency)

                    CustomPicker(title: "الفرع *", selection: $registrationData.branch)

                    Divider()
                        .padding(.vertical, ResponsiveLayout.smallSpacing)

                    Text("توصيل بطاقة ATM")
                        .font(.system(size: ResponsiveLayout.subtitleSize, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)

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
                        .padding(.vertical, ResponsiveLayout.smallSpacing)

                    Toggle("استخدام IBAN (اختياري)", isOn: $registrationData.useIban)
                        .font(.system(size: ResponsiveLayout.bodySize))
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
                .responsiveCardStyle()

                Spacer()

                // Navigation
                HStack(spacing: ResponsiveLayout.baseSpacing) {
                    CustomButton(title: "رجوع", action: {
                        registrationData.currentStep = 6
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
        VStack(spacing: ResponsiveLayout.baseSpacing) {
            Text("عنوان التوصيل")
                .font(.system(size: ResponsiveLayout.subtitleSize, weight: .semibold))
                .foregroundColor(AppColors.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .minimumScaleFactor(0.8)
                .lineLimit(1)

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
