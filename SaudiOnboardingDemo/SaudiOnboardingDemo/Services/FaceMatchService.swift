//
//  FaceMatchService.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import UIKit

class FaceMatchService {
    static let shared = FaceMatchService()

    private init() {}

    /// Demo Face Match - دائماً يرجع نجاح
    func verifyFace(idImage: UIImage, selfieImage: UIImage) async -> Result<FaceMatchResult, Error> {
        // محاكاة تأخير API
        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds

        // Demo: دائماً نجاح
        let result = FaceMatchResult(
            isMatch: true,
            confidence: 0.96,
            message: "تم التحقق من الوجه بنجاح ✅"
        )

        return .success(result)
    }
}

struct FaceMatchResult {
    let isMatch: Bool
    let confidence: Double
    let message: String
}

enum FaceMatchError: Error {
    case invalidImage
    case matchFailed
}
