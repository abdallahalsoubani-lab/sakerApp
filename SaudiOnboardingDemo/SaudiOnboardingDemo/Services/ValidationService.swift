//
//  ValidationService.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import Foundation

class ValidationService {
    static let shared = ValidationService()

    private init() {}

    func validate(_ value: String, pattern: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return false
        }
        let range = NSRange(location: 0, length: value.utf16.count)
        return regex.firstMatch(in: value, range: range) != nil
    }

    func isValidSaudiPhone(_ phone: String) -> Bool {
        return validate(phone, pattern: RegexPatterns.saudiPhone)
    }

    func isValidOtp(_ otp: String) -> Bool {
        return validate(otp, pattern: RegexPatterns.otp)
    }

    func isValidNationalId(_ id: String) -> Bool {
        return validate(id, pattern: RegexPatterns.nationalId)
    }

    func isValidArabicName(_ name: String) -> Bool {
        return validate(name, pattern: RegexPatterns.arabicName)
    }

    func isValidEnglishName(_ name: String) -> Bool {
        return validate(name, pattern: RegexPatterns.englishName)
    }

    func isValidEmail(_ email: String) -> Bool {
        return validate(email, pattern: RegexPatterns.email)
    }

    func isValidPassport(_ passport: String) -> Bool {
        return validate(passport, pattern: RegexPatterns.passport)
    }

    func isValidIncome(_ income: String) -> Bool {
        return validate(income, pattern: RegexPatterns.income)
    }

    func isValidWorkId(_ workId: String) -> Bool {
        return validate(workId, pattern: RegexPatterns.workId)
    }

    func isValidBuildingNumber(_ number: String) -> Bool {
        return validate(number, pattern: RegexPatterns.buildingNumber)
    }

    func isValidPostalCode(_ code: String) -> Bool {
        return validate(code, pattern: RegexPatterns.postalCode)
    }

    func isValidAdditionalNumber(_ number: String) -> Bool {
        return validate(number, pattern: RegexPatterns.additionalNumber)
    }

    func isValidUnitNumber(_ number: String) -> Bool {
        return validate(number, pattern: RegexPatterns.unitNumber)
    }

    func isValidIban(_ iban: String) -> Bool {
        return validate(iban, pattern: RegexPatterns.saudiIban)
    }

    func isValidUsername(_ username: String) -> Bool {
        return validate(username, pattern: RegexPatterns.username)
    }

    func isValidPassword(_ password: String) -> Bool {
        return validate(password, pattern: RegexPatterns.password)
    }
}
