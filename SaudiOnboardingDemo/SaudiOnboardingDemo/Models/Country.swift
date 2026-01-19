//
//  Country.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import Foundation

struct Country: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let nameArabic: String
    let code: String // مثل "SA"
    let dialCode: String // مثل "+966"
    let flag: String // الإيموجي للعلم
    
    static let saudiArabia = Country(
        name: "Saudi Arabia",
        nameArabic: "المملكة العربية السعودية",
        code: "SA",
        dialCode: "+966",
        flag: "🇸🇦"
    )
    
    static let uae = Country(
        name: "United Arab Emirates",
        nameArabic: "الإمارات العربية المتحدة",
        code: "AE",
        dialCode: "+971",
        flag: "🇦🇪"
    )
    
    static let kuwait = Country(
        name: "Kuwait",
        nameArabic: "الكويت",
        code: "KW",
        dialCode: "+965",
        flag: "🇰🇼"
    )
    
    static let qatar = Country(
        name: "Qatar",
        nameArabic: "قطر",
        code: "QA",
        dialCode: "+974",
        flag: "🇶🇦"
    )
    
    static let bahrain = Country(
        name: "Bahrain",
        nameArabic: "البحرين",
        code: "BH",
        dialCode: "+973",
        flag: "🇧🇭"
    )
    
    static let allCountries: [Country] = [
        .saudiArabia,
        .uae,
        .kuwait,
        .qatar,
        .bahrain
    ]
}
