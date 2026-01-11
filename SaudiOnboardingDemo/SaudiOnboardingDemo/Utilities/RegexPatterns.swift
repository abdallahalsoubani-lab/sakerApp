//
//  RegexPatterns.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import Foundation

struct RegexPatterns {
    // Step 0 - Phone & OTP
    static let saudiPhone = "^(009665|9665|\\+9665|05|5)(5|0|3|6|4|9|1|8|7)([0-9]{7})$"
    static let otp = "^\\d{6}$"

    // Step 1 - National ID/Iqama
    static let nationalId = "^[12]\\d{9}$"

    // Step 3 - Names
    static let arabicName = "^[\\u0600-\\u06FF\\s]{2,}$"
    static let englishName = "^[A-Za-z\\s]{2,}$"

    // Step 4 - Email & Passport
    static let email = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
    static let passport = "^[A-Za-z0-9]{6,12}$"
    static let spouseName = "^[\\u0600-\\u06FF\\s]{2,}$"

    // Step 5 - Income & Work ID
    static let income = "^\\d+(\\.\\d{1,2})?$"
    static let workId = "^[A-Za-z0-9\\-]{4,20}$"

    // Step 6 - Saudi National Address
    static let buildingNumber = "^\\d{4}$"
    static let streetName = "^[\\u0600-\\u06FF\\s]{2,}$"
    static let district = "^[\\u0600-\\u06FF\\s]{2,}$"
    static let postalCode = "^\\d{5}$"
    static let additionalNumber = "^\\d{4}$"
    static let unitNumber = "^\\d{1,6}$"

    // Step 7 - IBAN
    static let saudiIban = "^SA\\d{22}$"

    // Step 8 - Login Credentials
    static let username = "^[A-Za-z0-9._]{6,20}$"
    static let password = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[^A-Za-z0-9]).{8,}$"
}

struct ValidationMessages {
    // Step 0
    static let phoneError = "رقم الجوال غير صحيح. أدخل رقم سعودي صحيح مثل 05xxxxxxxx أو +9665xxxxxxxx"
    static let otpError = "رمز التحقق يجب أن يكون 6 أرقام"

    // Step 1
    static let nationalIdError = "رقم الهوية/الإقامة يجب أن يكون 10 أرقام ويبدأ بـ 1 أو 2"

    // Step 3
    static let arabicNameError = "الاسم بالعربي مطلوب ويجب أن يحتوي على حرفين على الأقل"
    static let englishNameError = "الاسم بالإنجليزي مطلوب ويجب أن يحتوي على حرفين على الأقل"

    // Step 4
    static let emailError = "البريد الإلكتروني غير صحيح"
    static let passportError = "رقم الجواز يجب أن يكون من 6 إلى 12 حرف/رقم"
    static let spouseNameError = "اسم الزوج/الزوجة مطلوب عند اختيار متزوج"

    // Step 5
    static let incomeError = "الدخل الشهري يجب أن يكون رقم صحيح"
    static let workIdError = "رقم تعريف العمل يجب أن يكون من 4 إلى 20 حرف/رقم"
    static let employerNameError = "اسم جهة العمل مطلوب"

    // Step 6
    static let buildingNumberError = "رقم المبنى يجب أن يكون 4 أرقام"
    static let streetNameError = "اسم الشارع مطلوب"
    static let districtError = "الحي/المنطقة مطلوب"
    static let postalCodeError = "الرمز البريدي يجب أن يكون 5 أرقام"
    static let additionalNumberError = "الرقم الإضافي يجب أن يكون 4 أرقام"
    static let unitNumberError = "رقم الوحدة يجب أن يكون من 1 إلى 6 أرقام"

    // Step 7
    static let ibanError = "رقم الآيبان السعودي يجب أن يبدأ بـ SA ويتبعه 22 رقم"

    // Step 8
    static let usernameError = "اسم المستخدم يجب أن يكون من 6 إلى 20 حرف/رقم"
    static let passwordError = "كلمة المرور يجب أن تحتوي على 8 أحرف على الأقل، حرف كبير، حرف صغير، رقم، ورمز خاص"
    static let passwordMatchError = "كلمة المرور غير متطابقة"

    // General
    static let requiredField = "هذا الحقل مطلوب"
}
