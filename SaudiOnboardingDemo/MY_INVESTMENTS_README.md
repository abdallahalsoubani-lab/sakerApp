# My Investments Feature / صفحة استثماراتي

## Overview / نظرة عامة

This document describes the new "My Investments" feature added to the SaudiOnboardingDemo app.

يصف هذا المستند ميزة "استثماراتي" الجديدة المضافة إلى تطبيق SaudiOnboardingDemo.

---

## Features / الميزات

### English
- **Bilingual Support**: Full Arabic and English localization
- **Dark/Light Mode**: Automatic theme support
- **Tab Bar Integration**: New tab added in the middle of the bottom navigation
- **Currency Display**: Uses the same SAR (﷼) logo as the rest of the app
- **Investment Overview**:
  - Total Investment amount
  - Current Value
  - Total Return with percentage
- **Statistics Cards**:
  - Total Funds count
  - Profit Distributions count
  - Total Return amount
- **Investment Cards**:
  - Property image
  - Location badge
  - Investment details (Invested, Current Value, Expected Return)
  - Progress bar showing completion percentage
  - "View Details" button

### العربية
- **دعم اللغتين**: دعم كامل للعربية والإنجليزية
- **الوضع الداكن/الفاتح**: دعم تلقائي للثيم
- **تكامل شريط التبويب**: تاب جديد مضاف في وسط شريط التنقل السفلي
- **عرض العملة**: يستخدم نفس شعار الريال (﷼) كبقية التطبيق
- **نظرة عامة على الاستثمارات**:
  - إجمالي مبلغ الاستثمار
  - القيمة الحالية
  - إجمالي العائد مع النسبة المئوية
- **بطاقات الإحصائيات**:
  - عدد الصناديق الإجمالي
  - عدد توزيعات الأرباح
  - مبلغ العائد الإجمالي
- **بطاقات الاستثمار**:
  - صورة العقار
  - شارة الموقع
  - تفاصيل الاستثمار (المستثمر، القيمة الحالية، العائد المتوقع)
  - شريط التقدم يوضح نسبة الإنجاز
  - زر "عرض التفاصيل"

---

## Files Created / الملفات المنشأة

### 1. Models
- **MyInvestment.swift** - Investment data model with mock data
  - موديل بيانات الاستثمار مع بيانات تجريبية

### 2. ViewModels
- **MyInvestmentsViewModel.swift** - Business logic and data management
  - منطق الأعمال وإدارة البيانات

### 3. Views
- **MyInvestmentsView.swift** - Main investments page with all UI components
  - الصفحة الرئيسية للاستثمارات مع جميع مكونات الواجهة

### 4. Updated Files / الملفات المحدثة
- **LocalizationManager.swift** - Added translations for the new page
  - أضيفت الترجمات للصفحة الجديدة
- **BottomNavigationBar.swift** - Added new tab in the middle
  - أضيف تاب جديد في الوسط
- **SaudiOnboardingDemoApp.swift** - Integrated new view in RootTabView
  - تم دمج العرض الجديد في RootTabView

---

## Navigation Structure / بنية التنقل

```
Tab Bar (4 tabs):
1. Invest (استثمر) - House icon
2. My Investments (استثماراتي) - Chart icon ⭐ NEW
3. Wallet (المحفظة) - Wallet icon
4. Profile (الملف الشخصي) - Person icon
```

---

## Design Features / ميزات التصميم

### English
1. **Consistent Theme**: Matches the existing app design
2. **Gradient Cards**: Dark gradient card for total investment
3. **Golden Accent**: Uses the signature golden color (RGB: 0.85, 0.75, 0.45)
4. **RTL Support**: Full right-to-left support for Arabic
5. **Responsive Layout**: Adapts to different screen sizes
6. **Shadow Effects**: Subtle shadows for depth
7. **Progress Indicators**: Visual progress bars with orange gradient
8. **Icon System**: Consistent SF Symbols usage

### العربية
1. **ثيم متناسق**: يطابق تصميم التطبيق الموجود
2. **بطاقات متدرجة**: بطاقة متدرجة داكنة لإجمالي الاستثمار
3. **لون ذهبي مميز**: يستخدم اللون الذهبي المميز (RGB: 0.85, 0.75, 0.45)
4. **دعم RTL**: دعم كامل للكتابة من اليمين لليسار للعربية
5. **تخطيط متجاوب**: يتكيف مع أحجام الشاشات المختلفة
6. **تأثيرات الظل**: ظلال خفيفة للعمق
7. **مؤشرات التقدم**: أشرطة تقدم مرئية بتدرج برتقالي
8. **نظام الأيقونات**: استخدام متسق لرموز SF

---

## Localization Keys / مفاتيح الترجمة

All text is localized using the following keys:

جميع النصوص مترجمة باستخدام المفاتيح التالية:

```swift
"myInvestments.title"
"myInvestments.totalInvestment"
"myInvestments.currentValue"
"myInvestments.totalReturn"
"myInvestments.totalFunds"
"myInvestments.profitDistributions"
"myInvestments.currentInvestments"
"myInvestments.invested"
"myInvestments.expectedReturn"
"myInvestments.progress"
"myInvestments.viewDetails"
"myInvestments.months"
"myInvestments.stats.funds"
"myInvestments.stats.distributions"
"myInvestments.stats.return"
```

---

## Mock Data / البيانات التجريبية

The page displays two mock investments:

تعرض الصفحة استثمارين تجريبيين:

1. **Riyadh Logistics Center 04 / مركز الرياض للخدمات اللوجستية ٠٤**
   - Invested: 100,000 SAR / المستثمر: ١٠٠،٠٠٠ ريال
   - Current Value: 175,000 SAR / القيمة الحالية: ١٧٥،٠٠٠ ريال
   - Return: 75% / العائد: ٧٥٪
   - Progress: 20% / التقدم: ٢٠٪

2. **Jeddah Corniche Heights / مرتفعات كورنيش جدة**
   - Invested: 150,000 SAR / المستثمر: ١٥٠،٠٠٠ ريال
   - Current Value: 252,375 SAR / القيمة الحالية: ٢٥٢،٣٧٥ ريال
   - Return: 68.25% / العائد: ٦٨.٢٥٪
   - Progress: 15% / التقدم: ١٥٪

**Total Investment: 250,000 SAR / إجمالي الاستثمار: ٢٥٠،٠٠٠ ريال**

---

## How to Test / كيفية الاختبار

### English
1. Open the project in Xcode
2. Build and run the app
3. Navigate to the "My Investments" tab (second tab in the bottom navigation)
4. Test language switching from the Profile tab
5. Test theme switching (Dark/Light mode) from the Profile tab
6. Verify all text is properly localized
7. Verify currency symbols display correctly
8. Check RTL layout in Arabic mode

### العربية
1. افتح المشروع في Xcode
2. قم ببناء وتشغيل التطبيق
3. انتقل إلى تاب "استثماراتي" (التاب الثاني في شريط التنقل السفلي)
4. اختبر تبديل اللغة من تاب الملف الشخصي
5. اختبر تبديل الثيم (الوضع الداكن/الفاتح) من تاب الملف الشخصي
6. تحقق من أن جميع النصوص مترجمة بشكل صحيح
7. تحقق من عرض رموز العملة بشكل صحيح
8. تحقق من تخطيط RTL في الوضع العربي

---

## Technical Implementation / التنفيذ التقني

### Architecture / البنية
- **MVVM Pattern**: Model-View-ViewModel architecture
  - نمط MVVM: بنية Model-View-ViewModel
- **SwiftUI**: Modern declarative UI framework
  - SwiftUI: إطار عمل واجهة تصريحي حديث
- **Combine**: Reactive programming for state management
  - Combine: برمجة تفاعلية لإدارة الحالة
- **ObservableObject**: For ViewModel state management
  - ObservableObject: لإدارة حالة ViewModel

### Components / المكونات
- **CurrencyText**: Reusable currency display component
  - مكون قابل لإعادة الاستخدام لعرض العملة
- **StatCard**: Statistics card component
  - مكون بطاقة الإحصائيات
- **InvestmentCard**: Investment detail card component
  - مكون بطاقة تفاصيل الاستثمار

---

## Future Enhancements / التحسينات المستقبلية

### English
1. Add investment detail page
2. Add filters (by property type, return rate, etc.)
3. Add sorting options
4. Add search functionality
5. Integrate with real API
6. Add pull-to-refresh
7. Add loading states
8. Add empty state when no investments
9. Add investment history graph
10. Add export functionality

### العربية
1. إضافة صفحة تفاصيل الاستثمار
2. إضافة فلاتر (حسب نوع العقار، معدل العائد، إلخ)
3. إضافة خيارات الترتيب
4. إضافة وظيفة البحث
5. التكامل مع API حقيقي
6. إضافة السحب للتحديث
7. إضافة حالات التحميل
8. إضافة حالة فارغة عندما لا توجد استثمارات
9. إضافة رسم بياني لتاريخ الاستثمار
10. إضافة وظيفة التصدير

---

## Support / الدعم

For questions or issues, please refer to the main README.md file.

للأسئلة أو المشاكل، يرجى الرجوع إلى ملف README.md الرئيسي.

---

**Created by: Cursor AI Assistant**  
**تاريخ الإنشاء: ١٢ يناير ٢٠٢٦**  
**Date: January 12, 2026**
