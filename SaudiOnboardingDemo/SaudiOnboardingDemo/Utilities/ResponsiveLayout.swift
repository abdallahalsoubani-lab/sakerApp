//
//  ResponsiveLayout.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import SwiftUI

// MARK: - Responsive Layout Helper
/// يوفر قيم متجاوبة بناءً على حجم الشاشة
struct ResponsiveLayout {
    
    // MARK: - Screen Dimensions
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    
    /// نوع الجهاز بناءً على العرض
    enum DeviceType {
        case small      // iPhone SE, 12 mini (width < 380)
        case regular    // iPhone 12, 13, 14 (380-400)
        case large      // iPhone 12 Pro Max, 14 Plus (400-430)
        case extraLarge // iPhone 14 Pro Max, 15 Pro Max (>430)
        
        static var current: DeviceType {
            let width = UIScreen.main.bounds.width
            switch width {
            case ..<380:
                return .small
            case 380..<400:
                return .regular
            case 400..<430:
                return .large
            default:
                return .extraLarge
            }
        }
    }
    
    // MARK: - Spacing
    /// مسافة أساسية متجاوبة (تتناسب مع حجم الشاشة)
    static var baseSpacing: CGFloat {
        switch DeviceType.current {
        case .small:
            return 12
        case .regular:
            return 16
        case .large:
            return 18
        case .extraLarge:
            return 20
        }
    }
    
    /// مسافة بين الأقسام (Sections)
    static var sectionSpacing: CGFloat {
        switch DeviceType.current {
        case .small:
            return 16
        case .regular:
            return 20
        case .large:
            return 24
        case .extraLarge:
            return 28
        }
    }
    
    /// مسافة صغيرة
    static var smallSpacing: CGFloat {
        return baseSpacing * 0.5
    }
    
    /// مسافة كبيرة
    static var largeSpacing: CGFloat {
        return baseSpacing * 1.5
    }
    
    // MARK: - Padding
    /// حواف أفقية (Horizontal Gutter)
    static var horizontalPadding: CGFloat {
        switch DeviceType.current {
        case .small:
            return 16
        case .regular:
            return 20
        case .large:
            return 24
        case .extraLarge:
            return 28
        }
    }
    
    /// حواف عمودية
    static var verticalPadding: CGFloat {
        return baseSpacing
    }
    
    /// حواف البطاقات (Cards)
    static var cardPadding: CGFloat {
        switch DeviceType.current {
        case .small:
            return 14
        case .regular:
            return 16
        case .large:
            return 18
        case .extraLarge:
            return 20
        }
    }
    
    // MARK: - Corner Radius
    static var cornerRadius: CGFloat {
        return 12
    }
    
    static var largeCornerRadius: CGFloat {
        return 20
    }
    
    static var buttonCornerRadius: CGFloat {
        return 12
    }
    
    // MARK: - Font Sizes
    /// حجم خط العنوان الكبير
    static var largeTitleSize: CGFloat {
        switch DeviceType.current {
        case .small:
            return 28
        case .regular:
            return 32
        case .large:
            return 34
        case .extraLarge:
            return 36
        }
    }
    
    /// حجم خط العنوان
    static var titleSize: CGFloat {
        switch DeviceType.current {
        case .small:
            return 20
        case .regular:
            return 22
        case .large:
            return 24
        case .extraLarge:
            return 26
        }
    }
    
    /// حجم خط العنوان الفرعي
    static var subtitleSize: CGFloat {
        switch DeviceType.current {
        case .small:
            return 16
        case .regular:
            return 17
        case .large:
            return 18
        case .extraLarge:
            return 19
        }
    }
    
    /// حجم خط النص الأساسي
    static var bodySize: CGFloat {
        return 15
    }
    
    /// حجم خط النص الصغير
    static var captionSize: CGFloat {
        return 13
    }
    
    // MARK: - Button Heights
    static var buttonHeight: CGFloat {
        switch DeviceType.current {
        case .small:
            return 48
        case .regular:
            return 52
        case .large:
            return 54
        case .extraLarge:
            return 56
        }
    }
    
    // MARK: - Image Heights
    /// ارتفاع صورة البطاقة
    static var cardImageHeight: CGFloat {
        switch DeviceType.current {
        case .small:
            return 180
        case .regular:
            return 200
        case .large:
            return 220
        case .extraLarge:
            return 240
        }
    }
    
    /// ارتفاع الصورة الكبيرة (Hero Image)
    static var heroImageHeight: CGFloat {
        // نسبة من ارتفاع الشاشة
        return screenHeight * 0.35
    }
    
    /// ارتفاع صورة الهوية
    static var idImageHeight: CGFloat {
        switch DeviceType.current {
        case .small:
            return 160
        case .regular:
            return 180
        case .large:
            return 200
        case .extraLarge:
            return 220
        }
    }
    
    // MARK: - Icon Sizes
    static var iconSize: CGFloat {
        switch DeviceType.current {
        case .small:
            return 40
        case .regular:
            return 44
        case .large:
            return 48
        case .extraLarge:
            return 52
        }
    }
    
    static var smallIconSize: CGFloat {
        return iconSize * 0.7
    }
    
    static var largeIconSize: CGFloat {
        return iconSize * 1.2
    }
    
    // MARK: - Shadows
    static var shadowRadius: CGFloat {
        return 10
    }
    
    static var shadowOpacity: Double {
        return 0.08
    }
}

// MARK: - View Extensions
extension View {
    /// تطبيق الحواف المتجاوبة (Responsive Padding)
    func responsivePadding() -> some View {
        self.padding(.horizontal, ResponsiveLayout.horizontalPadding)
    }
    
    /// تطبيق تنسيق البطاقة المتجاوب
    func responsiveCardStyle() -> some View {
        self
            .padding(ResponsiveLayout.cardPadding)
            .background(AppColors.cardBackground)
            .cornerRadius(ResponsiveLayout.cornerRadius)
            .shadow(
                color: Color.black.opacity(ResponsiveLayout.shadowOpacity),
                radius: ResponsiveLayout.shadowRadius,
                x: 0,
                y: 4
            )
    }
    
    /// إخفاء لوحة المفاتيح عند النقر
    func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

// MARK: - Device Info Extension
extension UIDevice {
    /// هل الجهاز iPad
    var isiPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /// هل الجهاز iPhone صغير
    var isSmallPhone: Bool {
        ResponsiveLayout.DeviceType.current == .small
    }
    
    /// هل الجهاز iPhone كبير
    var isLargePhone: Bool {
        ResponsiveLayout.DeviceType.current == .large || ResponsiveLayout.DeviceType.current == .extraLarge
    }
}
