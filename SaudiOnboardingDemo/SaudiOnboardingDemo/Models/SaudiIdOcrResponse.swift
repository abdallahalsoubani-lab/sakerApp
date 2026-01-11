//
//  SaudiIdOcrResponse.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import Foundation

struct SaudiIdOcrResponse: Codable {
    let documentType: String
    let confidence: Double
    let fields: SaudiIdOcrFields
}

struct SaudiIdOcrFields: Codable {
    let nationalId: String?
    let fullNameArabic: String?
    let fullNameEnglish: String?
    let dobHijri: String?
    let expiryHijri: String?
    let placeOfBirthArabic: String?
}
