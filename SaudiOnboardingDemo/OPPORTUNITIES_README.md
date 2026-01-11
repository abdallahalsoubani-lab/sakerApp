# Opportunities Feature - Investment Platform

## Overview
صفحة الفرص الاستثمارية (Opportunities View) هي الصفحة الرئيسية للتطبيق وتعرض فرص الاستثمار العقاري المتاحة.

## Architecture - Clean Architecture

### 1. Models Layer (`Models/`)
- **InvestmentOpportunity.swift**: نموذج البيانات الأساسي للفرصة الاستثمارية
  - يحتوي على جميع خصائص الفرصة (العنوان، الموقع، النوع، العائد، إلخ)
  - يتضمن Enums للأنواع والحالات
  - يحتوي على Mock Data للتجربة

### 2. ViewModels Layer (`ViewModels/`)
- **OpportunitiesViewModel.swift**: ViewModel يدير حالة الصفحة والمنطق
  - يستخدم `@Published` properties للتحديث التلقائي
  - يدير الفلترة والبحث باستخدام Combine
  - يفصل منطق العمل عن واجهة المستخدم

### 3. Views Layer (`Views/Opportunities/`)
- **OpportunitiesView.swift**: الصفحة الرئيسية
  - تعرض Header مع العنوان
  - شريط البحث
  - أزرار الفلترة (All, Residential, Commercial, Industrial)
  - قائمة الفرص الاستثمارية
  - شريط التنقل السفلي

- **OpportunityCard.swift**: بطاقة عرض الفرصة الاستثمارية
  - صورة العقار مع overlay
  - معلومات الموقع والعنوان
  - إحصائيات (Return, Yield, Min Investment)
  - شريط التقدم للتمويل
  - حالة Coming Soon إن وجدت

- **BottomNavigationBar.swift**: شريط التنقل السفلي
  - 3 tabs: Invest, Wallet, Profile
  - مؤشر نشط للتبويب الحالي

## Features

### 1. Search & Filter
- بحث في العنوان والموقع
- فلترة حسب نوع العقار (All, Residential, Commercial, Industrial)
- تحديث فوري للنتائج باستخدام Combine

### 2. Investment Cards
- عرض جذاب للفرص الاستثمارية
- معلومات واضحة عن العائد والتمويل
- دعم حالة "Coming Soon" للفرص القادمة

### 3. Responsive Design
- تصميم يتكيف مع أحجام الشاشات المختلفة
- استخدام LazyVStack للأداء الأمثل
- Animations سلسة للتفاعلات

## Code Quality

### Clean Code Principles
- ✅ Single Responsibility: كل ملف له مسؤولية واحدة
- ✅ Separation of Concerns: فصل Models, ViewModels, Views
- ✅ DRY (Don't Repeat Yourself): مكونات قابلة لإعادة الاستخدام
- ✅ Readable & Maintainable: أسماء واضحة وتعليقات مفيدة

### SwiftUI Best Practices
- استخدام `@StateObject` للـ ViewModel
- استخدام `@Published` للـ reactive updates
- استخدام Combine للـ data transformation
- استخدام LazyVStack للأداء
- استخدام ViewBuilder للمكونات

### MVVM Architecture
```
┌─────────────────┐
│     Views       │ ← User Interface
└────────┬────────┘
         │ Binding
┌────────▼────────┐
│   ViewModels    │ ← Business Logic
└────────┬────────┘
         │ Data
┌────────▼────────┐
│     Models      │ ← Data Layer
└─────────────────┘
```

## File Structure
```
SaudiOnboardingDemo/
├── Models/
│   └── InvestmentOpportunity.swift
├── ViewModels/
│   └── OpportunitiesViewModel.swift
├── Views/
│   └── Opportunities/
│       ├── OpportunitiesView.swift
│       ├── OpportunityCard.swift
│       └── BottomNavigationBar.swift
└── Assets.xcassets/
    ├── industrial_building.imageset/
    ├── jeddah_corniche.imageset/
    ├── dubai_offices.imageset/
    └── warehouse_complex.imageset/
```

## Usage

### Running the App
1. افتح المشروع في Xcode
2. اختر Simulator أو جهاز
3. اضغط على Run (⌘R)

### Customization
لإضافة فرصة استثمارية جديدة، أضف عنصر جديد في `InvestmentOpportunity.mockData`:

```swift
InvestmentOpportunity(
    title: "عنوان المشروع",
    location: "الموقع",
    type: .residential, // أو .commercial أو .industrial
    imageName: "اسم_الصورة",
    returnRate: 7.5,
    yieldRate: 6.2,
    minInvestment: 3000,
    fundedPercentage: 45,
    targetAmount: 30.0
)
```

## Design Specifications

### Colors
- Primary Text: `.primary` (Black in light mode)
- Secondary Text: `.secondary` (Gray)
- Accent: Orange (#FF9500)
- Background: System Background
- Card Background: White

### Typography
- Header: 32pt, Bold
- Subtitle: 15pt, Regular
- Card Title: 24pt, Bold
- Stats: 20pt, Bold
- Labels: 11-14pt, Medium/Regular

### Spacing
- Card Padding: 16pt
- Section Spacing: 20pt
- Element Spacing: 12pt
- Corner Radius: 12-16pt

## Future Enhancements
- [ ] إضافة API integration
- [ ] إضافة صفحة تفاصيل الفرصة
- [ ] إضافة Favorites
- [ ] إضافة Sorting options
- [ ] إضافة Map view
- [ ] إضافة Investment calculator

## Notes
- الصور الحالية هي placeholders - يمكن استبدالها بصور حقيقية
- البيانات حالياً mock data - يمكن ربطها بـ API
- التصميم responsive ويعمل على جميع أحجام الشاشات
