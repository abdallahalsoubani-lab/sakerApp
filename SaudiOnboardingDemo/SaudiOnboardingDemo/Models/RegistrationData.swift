//
//  RegistrationData.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import Foundation
import SwiftUI
import CoreLocation

class RegistrationData: ObservableObject {
    // Step 0 - Phone & OTP
    @Published var selectedCountry: Country = Country.saudiArabia
    @Published var phoneNumber: String = ""
    @Published var otp: String = ""
    @Published var generatedOtp: String = ""
    @Published var isOtpVerified: Bool = false

    // Step 1 - KYC Basic Info
    @Published var nationality: Nationality = .saudi
    @Published var residencyStatus: ResidencyStatus = .citizen
    @Published var nationalId: String = ""
    @Published var isPEP: YesNo = .no
    @Published var isBeneficialOwner: YesNo = .yes
    @Published var isUSPerson: YesNo = .no
    @Published var workSector: WorkSector = .privateSector

    // Step 2 - ID Scan & OCR
    @Published var idImage: UIImage?
    @Published var ocrResponse: SaudiIdOcrResponse?
    @Published var isFaceVerified: Bool = false
    @Published var faceImage: UIImage?

    // Step 3 - Names
    @Published var fullNameArabic: String = ""
    @Published var fullNameEnglish: String = ""
    @Published var isArabicNameFromOCR: Bool = false
    @Published var isEnglishNameFromOCR: Bool = false

    // Step 4 - Contact & Marital Status
    @Published var email: String = ""
    @Published var educationLevel: EducationLevel = .bachelor
    @Published var maritalStatus: MaritalStatus = .single
    @Published var spouseName: String = ""
    @Published var passportNumber: String = ""
    @Published var passportIssueDate: Date?
    @Published var passportExpiryDate: Date?

    // Step 5 - Job & Income
    @Published var profession: Profession = .employee
    @Published var monthlyIncome: String = ""
    @Published var currency: Currency = .sar
    @Published var employerName: String = ""
    @Published var workCity: City = .riyadh
    @Published var workLocation: CLLocationCoordinate2D?
    @Published var workId: String = ""
    @Published var workIdExpiryDate: Date?

    // Step 6 - National Address
    @Published var buildingNumber: String = ""
    @Published var streetName: String = ""
    @Published var district: String = ""
    @Published var city: City = .riyadh
    @Published var postalCode: String = ""
    @Published var additionalNumber: String = ""
    @Published var unitNumber: String = ""
    @Published var homeLocation: CLLocationCoordinate2D?

    // Step 7 - Account Details
    @Published var accountType: AccountType = .current
    @Published var accountCurrency: Currency = .sar
    @Published var branch: Branch = .riyadhMain
    @Published var deliveryLocation: DeliveryLocation = .home
    @Published var useIban: Bool = false
    @Published var iban: String = ""

    // Delivery Address (if other)
    @Published var deliveryBuildingNumber: String = ""
    @Published var deliveryStreetName: String = ""
    @Published var deliveryDistrict: String = ""
    @Published var deliveryCity: City = .riyadh
    @Published var deliveryPostalCode: String = ""
    @Published var deliveryAdditionalNumber: String = ""
    @Published var deliveryUnitNumber: String = ""
    @Published var deliveryLocationCoordinate: CLLocationCoordinate2D?

    // Step 8 - Login Credentials
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    // Navigation
    @Published var currentStep: Int = 0

    func reset() {
        currentStep = 0
        phoneNumber = ""
        otp = ""
        isOtpVerified = false
        // يمكن إضافة reset لباقي الحقول إذا لزم الأمر
    }
}
