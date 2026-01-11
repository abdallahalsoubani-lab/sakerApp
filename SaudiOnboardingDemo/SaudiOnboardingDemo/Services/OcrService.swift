//
//  OcrService.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import UIKit

class OcrService {
    static let shared = OcrService()

    private init() {}

    /// Demo OCR - يرجع بيانات ثابتة
    func performOCR(on image: UIImage) async -> Result<SaudiIdOcrResponse, Error> {
        // محاكاة تأخير API
        try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds

        // بيانات Demo ثابتة
        let demoResponse = SaudiIdOcrResponse(
            documentType: "SA_NATIONAL_ID",
            confidence: 0.93,
            fields: SaudiIdOcrFields(
                nationalId: "1234567890",
                fullNameArabic: "محمد بن عبدالله بن أحمد",
                fullNameEnglish: "Mohammed Abdullah Ahmed",
                dobHijri: "1400/01/01",
                expiryHijri: "1450/01/01",
                placeOfBirthArabic: "الرياض"
            )
        )

        return .success(demoResponse)
    }
}

enum OcrError: Error {
    case invalidImage
    case ocrFailed
}
