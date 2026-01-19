//
//  LocalizationManager.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import Foundation
import SwiftUI
import Combine

// MARK: - Language Type
enum AppLanguage: String, CaseIterable {
    case english = "en"
    case arabic = "ar"
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .arabic: return "العربية"
        }
    }
    
    var isRTL: Bool {
        self == .arabic
    }
}

// MARK: - Localization Manager
class LocalizationManager: ObservableObject {
    
    // MARK: - Singleton
    static let shared = LocalizationManager()
    
    // MARK: - Published Properties
    @Published var currentLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "app_language")
            updateLayoutDirection()
        }
    }
    
    // MARK: - Initialization
    private init() {
        // Load saved language or default to Arabic
        let savedLanguage = UserDefaults.standard.string(forKey: "app_language") ?? AppLanguage.arabic.rawValue
        self.currentLanguage = AppLanguage(rawValue: savedLanguage) ?? .arabic
        updateLayoutDirection()
    }
    
    // MARK: - Public Methods
    func toggleLanguage() {
        withAnimation {
            currentLanguage = currentLanguage == .english ? .arabic : .english
        }
    }
    
    func setLanguage(_ language: AppLanguage) {
        withAnimation {
            currentLanguage = language
        }
    }
    
    // MARK: - Private Methods
    private func updateLayoutDirection() {
        // Update layout direction for RTL support
        if currentLanguage.isRTL {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }
}

// MARK: - Localized Strings
struct LocalizedStrings {
    
    static func get(_ key: String) -> String {
        let language = LocalizationManager.shared.currentLanguage
        return strings[key]?[language] ?? key
    }
    
    // MARK: - String Dictionary
    private static let strings: [String: [AppLanguage: String]] = [
        
        // MARK: - Bottom Navigation
        "nav.invest": [.english: "Invest", .arabic: "استثمر"],
        "nav.myInvestments": [.english: "My Investments", .arabic: "استثماراتي"],
        "nav.wallet": [.english: "Wallet", .arabic: "المحفظة"],
        "nav.profile": [.english: "Profile", .arabic: "الملف الشخصي"],
        
        // MARK: - Opportunities Screen
        "opportunities.title": [.english: "Opportunities", .arabic: "الفرص"],
        "opportunities.subtitle": [.english: "Explore vetted real estate assets", .arabic: "استكشف الأصول العقارية المعتمدة"],
        "opportunities.search": [.english: "Search location or asset...", .arabic: "البحث عن موقع أو أصل..."],
        
        // MARK: - Property Types
        "property.all": [.english: "All", .arabic: "الكل"],
        "property.residential": [.english: "Residential", .arabic: "سكني"],
        "property.commercial": [.english: "Commercial", .arabic: "تجاري"],
        "property.industrial": [.english: "Industrial", .arabic: "صناعي"],
        
        // MARK: - Investment Status
        "status.active": [.english: "LIVE FUNDING", .arabic: "تمويل مباشر"],
        "status.comingSoon": [.english: "COMING SOON", .arabic: "قريباً"],
        
        // MARK: - Investment Card
        "card.return": [.english: "RETURN", .arabic: "العائد"],
        "card.yield": [.english: "YIELD", .arabic: "الإيراد"],
        "card.minInv": [.english: "MIN INV", .arabic: "الحد الأدنى"],
        "card.funded": [.english: "Funded", .arabic: "ممول"],
        "card.target": [.english: "Target", .arabic: "الهدف"],
        "card.comingSoon": [.english: "Opens for funding in %d days", .arabic: "يفتح للتمويل خلال %d أيام"],
        
        // MARK: - Investment Detail
        "detail.annualReturn": [.english: "ANNUAL RETURN", .arabic: "العائد السنوي"],
        "detail.distribution": [.english: "DISTRIBUTION", .arabic: "التوزيع"],
        "detail.monthly": [.english: "Monthly", .arabic: "شهري"],
        "detail.term": [.english: "TERM", .arabic: "المدة"],
        "detail.years": [.english: "5 Years", .arabic: "٥ سنوات"],
        "detail.fundingProgress": [.english: "Funding Progress", .arabic: "تقدم التمويل"],
        "detail.available": [.english: "% Available", .arabic: "% متاح"],
        "detail.fundedAmount": [.english: "Funded: %@ SAR", .arabic: "ممول: %@ ريال"],
        "detail.targetAmount": [.english: "Target: %@ SAR", .arabic: "الهدف: %@ ريال"],
        "detail.viewers": [.english: "investors viewed this today", .arabic: "مستثمر شاهد هذا اليوم"],
        "detail.annualIncome": [.english: "Annual Income", .arabic: "الدخل السنوي"],
        "detail.appreciation": [.english: "Appreciation", .arabic: "الزيادة"],
        "detail.timeline": [.english: "Investment Timeline", .arabic: "الجدول الزمني للاستثمار"],
        "detail.dueDiligence": [.english: "Due Diligence", .arabic: "العناية الواجبة"],
        "detail.cmaRegulated": [.english: "CMA REGULATED", .arabic: "مرخص من هيئة السوق المالية"],
        "detail.shariahCompliant": [.english: "SHARIAH\nCOMPLIANT", .arabic: "متوافق مع\nالشريعة"],
        "detail.addToCart": [.english: "Add to Cart", .arabic: "أضف للسلة"],
        "detail.minInvestment": [.english: "MIN INVESTMENT", .arabic: "الحد الأدنى للاستثمار"],
        "detail.current": [.english: "CURRENT", .arabic: "الحالي"],
        
        // MARK: - Timeline Items
        "timeline.fundraising": [.english: "nvestor fundraising period", .arabic: "فترة جمع المستثمرين"],
        "timeline.fundraisingDesc": [.english: "Initial capital raising phase.", .arabic: "مرحلة جمع رأس المال الأولي."],
        "timeline.acquisition": [.english: "Property Acquisition", .arabic: "اقتناء العقار"],
        "timeline.acquisitionDesc": [.english: "Asset transfer and registration.", .arabic: "نقل الأصول والتسجيل."],
        "timeline.firstDividend": [.english: "First Dividend", .arabic: "أول توزيع أرباح"],
        "timeline.firstDividendDesc": [.english: "Expected first monthly payout.", .arabic: "الدفعة الشهرية الأولى المتوقعة."],
        "timeline.exitStrategy": [.english: "Exit Strategy", .arabic: "استراتيجية الخروج"],
        "timeline.exitStrategyDesc": [.english: "Projected sale or refinancing.", .arabic: "البيع المتوقع أو إعادة التمويل."],
        
        // MARK: - Documents
        "doc.fundMemo": [.english: "Fund Memo EN", .arabic: "مذكرة الصندوق"],
        "doc.executiveSummary": [.english: "Executive Summary", .arabic: "الملخص التنفيذي"],
        "doc.shariahCert": [.english: "Shariah Certificate", .arabic: "شهادة الشريعة"],
        "doc.valuationReport": [.english: "Valuation Report", .arabic: "تقرير التقييم"],
        
        // MARK: - Wallet Screen
        "wallet.title": [.english: "Wallet", .arabic: "المحفظة"],
        "wallet.totalBalance": [.english: "Total Balance", .arabic: "الرصيد الكلي"],
        "wallet.topUp": [.english: "Top Up", .arabic: "شحن"],
        "wallet.withdraw": [.english: "Withdraw", .arabic: "سحب"],
        "wallet.availableToInvest": [.english: "Available to Invest", .arabic: "متاح للاستثمار"],
        "wallet.totalInvested": [.english: "Total Invested", .arabic: "إجمالي المستثمر"],
        "wallet.recentTransactions": [.english: "Recent Transactions", .arabic: "المعاملات الأخيرة"],
        
        // MARK: - Transaction Types
        "transaction.topUp": [.english: "Top Up via Apple Pay", .arabic: "شحن عبر Apple Pay"],
        "transaction.investment": [.english: "Investment: Riyadh Logistics", .arabic: "استثمار: الرياض للخدمات اللوجستية"],
        "transaction.dividend": [.english: "Dividend Payment (Q4)", .arabic: "دفع الأرباح (الربع الرابع)"],
        "transaction.withdrawal": [.english: "Withdrawal to SABB Bank", .arabic: "سحب إلى بنك ساب"],
        
        // MARK: - Transaction Status
        "status.completed": [.english: "Completed", .arabic: "مكتمل"],
        "status.processing": [.english: "Processing", .arabic: "قيد المعالجة"],
        
        // MARK: - Transaction Dates
        "date.today": [.english: "Today", .arabic: "اليوم"],
        "date.yesterday": [.english: "Yesterday", .arabic: "أمس"],
        
        // MARK: - Profile Screen
        "profile.title": [.english: "Profile", .arabic: "الملف الشخصي"],
        "profile.name": [.english: "Sultan Al-Otaibi", .arabic: "سلطان العتيبي "],
        "profile.email": [.english: "Sultan@example.com", .arabic: "Sultan@example.com"],
        "profile.accredited": [.english: "ACCREDITED", .arabic: "معتمد"],
        "profile.verified": [.english: "Account Verified", .arabic: "الحساب موثق"],
        "profile.verifiedDesc": [.english: "Your KYC is complete and up to date.", .arabic: "اكتمل التحقق من هويتك ومحدث."],
        
        // MARK: - Profile Sections
        "profile.accountSettings": [.english: "ACCOUNT SETTINGS", .arabic: "إعدادات الحساب"],
        "profile.financial": [.english: "FINANCIAL", .arabic: "المالية"],
        "profile.supportLegal": [.english: "SUPPORT & LEGAL", .arabic: "الدعم والقانون"],
        
        // MARK: - Profile Menu Items
        "profile.personalInfo": [.english: "Personal Information", .arabic: "المعلومات الشخصية"],
        "profile.notifications": [.english: "Notifications", .arabic: "الإشعارات"],
        "profile.language": [.english: "Language", .arabic: "اللغة"],
        "profile.theme": [.english: "Theme", .arabic: "المظهر"],
        "profile.preferences": [.english: "Preferences", .arabic: "التفضيلات"],
        "profile.paymentMethods": [.english: "Payment Methods", .arabic: "طرق الدفع"],
        "profile.documents": [.english: "Documents & Statements", .arabic: "المستندات والكشوف"],
        "profile.taxReports": [.english: "Tax Reports", .arabic: "التقارير الضريبية"],
        "profile.helpCenter": [.english: "Help Center", .arabic: "مركز المساعدة"],
        "profile.terms": [.english: "Terms & Conditions", .arabic: "الشروط والأحكام"],
        "profile.privacy": [.english: "Privacy Policy", .arabic: "سياسة الخصوصية"],
        "profile.logout": [.english: "Log Out", .arabic: "تسجيل الخروج"],
        
        // MARK: - Investment Opportunities Mock Data
        "opportunity.logisticsPark": [.english: "LAYSEN Valley", .arabic: "ليسن فالي"],
        "opportunity.logisticsParkLocation": [.english: "Riyadh", .arabic: "الرياض"],
        "opportunity.riyadhFront": [.english: "the business gate", .arabic: "البوابة الاقتصادية"],
        "opportunity.riyadhFrontLocation": [.english: "Riyadh", .arabic: "الرياض"],
        "opportunity.theZone": [.english: "RIYADH FRONT", .arabic: "واجهة الرياض"],
        "opportunity.theZoneLocation": [.english: "Riyadh", .arabic: "الرياض"],
        "opportunity.laysenValley": [.english: "Tha Zone", .arabic: "ذا زون"],
        "opportunity.laysenValleyLocation": [.english: "Riyadh", .arabic: "الرياض"],
        
        // MARK: - Company Info
        "company.archCapital": [.english: "Arch Capital", .arabic: "آرش كابيتال"],
        "company.archCapitalDesc": [.english: "Established in 2020, a CMA-licensed investment firm specializing in industrial logistics assets across the GCC region.", .arabic: "تأسست في ٢٠٢٠، شركة استثمارية مرخصة من هيئة السوق المالية متخصصة في الأصول اللوجستية الصناعية في منطقة الخليج."],
        
        // MARK: - Currency
        "currency.sar": [.english: "SAR", .arabic: "ريال"],
        
        // MARK: - Theme Mode
        "theme.light": [.english: "Light", .arabic: "فاتح"],
        "theme.dark": [.english: "Dark", .arabic: "داكن"],
        "theme.system": [.english: "System", .arabic: "النظام"],
        "theme.title": [.english: "Appearance", .arabic: "المظهر"],
        
        // MARK: - Splash Screen
        "splash.welcome": [.english: "Welcome", .arabic: "مرحباً"],
        "splash.subtitle": [.english: "Start your investment journey", .arabic: "ابدأ رحلتك الاستثمارية"],
        "splash.register": [.english: "Create Account", .arabic: "إنشاء حساب"],
        "splash.explore": [.english: "Explore Investments", .arabic: "استكشف الفرص"],
        
        // MARK: - My Investments Screen
        "myInvestments.title": [.english: "My Investments", .arabic: "استثماراتي"],
        "myInvestments.totalInvestment": [.english: "Total Investment", .arabic: "إجمالي الاستثمار"],
        "myInvestments.currentValue": [.english: "Current Value", .arabic: "القيمة الحالية"],
        "myInvestments.totalReturn": [.english: "Total Return", .arabic: "العائد الإجمالي"],
        "myInvestments.totalFunds": [.english: "Total Funds", .arabic: "مجموع الصناديق"],
        "myInvestments.profitDistributions": [.english: "Profit Distributions", .arabic: "توزيعات الأرباح"],
        "myInvestments.currentInvestments": [.english: "Current Investments", .arabic: "الاستثمارات الحالية"],
        "myInvestments.previousInvestments": [.english: "Previous Investments", .arabic: "استثمارات سابقة"],
        "myInvestments.invested": [.english: "Invested", .arabic: "المبلغ المستثمر"],
        "myInvestments.expectedReturn": [.english: "Expected Return", .arabic: "العائد المتوقع"],
        "myInvestments.progress": [.english: "completed", .arabic: "مكتمل"],
        "myInvestments.viewDetails": [.english: "View Details", .arabic: "عرض التفاصيل"],
        "myInvestments.months": [.english: "48 months", .arabic: "٤٨ شهر"],
        "myInvestments.stats.funds": [.english: "Funds", .arabic: "الصناديق"],
        "myInvestments.stats.distributions": [.english: "Distributions", .arabic: "التوزيعات"],
        "myInvestments.stats.return": [.english: "Return", .arabic: "العائد"],
    ]
}

// MARK: - View Extension
extension View {
    func localizedEnvironment() -> some View {
        self.environment(\.layoutDirection, LocalizationManager.shared.currentLanguage.isRTL ? .rightToLeft : .leftToRight)
    }
}
