//
//  Enums.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import Foundation

// Step 1 Enums
enum Nationality: String, CaseIterable {
    case saudi = "سعودي"
    case resident = "مقيم"
    case other = "جنسيات أخرى"
}

enum ResidencyStatus: String, CaseIterable {
    case citizen = "مواطن"
    case resident = "مقيم"
}

enum YesNo: String, CaseIterable {
    case yes = "نعم"
    case no = "لا"
}

enum WorkSector: String, CaseIterable {
    case government = "حكومي"
    case privateSector = "خاص"
    case selfEmployed = "أعمال حرة"
    case student = "طالب"
    case unemployed = "بدون عمل"
    case retired = "متقاعد"
}

// Step 4 Enums
enum EducationLevel: String, CaseIterable {
    case secondary = "ثانوي"
    case diploma = "دبلوم"
    case bachelor = "بكالوريوس"
    case master = "ماجستير"
    case phd = "دكتوراه"
    case other = "أخرى"
}

enum MaritalStatus: String, CaseIterable {
    case single = "أعزب/عزباء"
    case married = "متزوج/متزوجة"
    case divorced = "مطلق/مطلقة"
    case widowed = "أرمل/أرملة"
}

// Step 5 Enums
enum Profession: String, CaseIterable {
    case engineer = "مهندس"
    case doctor = "طبيب"
    case teacher = "معلم"
    case accountant = "محاسب"
    case manager = "مدير"
    case employee = "موظف"
    case businessman = "رجل أعمال"
    case student = "طالب"
    case other = "أخرى"
}

enum Currency: String, CaseIterable {
    case sar = "SAR"
    case usd = "USD"
    case eur = "EUR"
    case aed = "AED"
}

enum City: String, CaseIterable {
    case riyadh = "الرياض"
    case jeddah = "جدة"
    case dammam = "الدمام"
    case mecca = "مكة"
    case medina = "المدينة"
    case khobar = "الخبر"
    case taif = "الطائف"
    case tabuk = "تبوك"
    case buraidah = "بريدة"
    case khamis = "خميس مشيط"
    case other = "أخرى"
}

// Step 7 Enums
enum AccountType: String, CaseIterable {
    case current = "Current"
    case savings = "Savings"
}

enum Branch: String, CaseIterable {
    case riyadhMain = "الرياض الرئيسي"
    case jeddahMain = "جدة الرئيسي"
    case dammamMain = "الدمام الرئيسي"
    case other = "فرع آخر"
}

enum DeliveryLocation: String, CaseIterable {
    case home = "المنزل"
    case branch = "الفرع"
    case other = "عنوان آخر"
}
