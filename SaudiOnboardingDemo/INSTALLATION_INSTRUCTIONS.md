# Installation Instructions / تعليمات التثبيت

## Adding New Files to Xcode Project / إضافة الملفات الجديدة إلى مشروع Xcode

⚠️ **Important / مهم**: The new files have been created but need to be added to the Xcode project manually.

⚠️ **مهم**: تم إنشاء الملفات الجديدة ولكن يجب إضافتها إلى مشروع Xcode يدوياً.

---

## Quick Start / البدء السريع

### Option 1: Automatic (Recommended) / الخيار 1: تلقائي (موصى به)

1. **Close Xcode** if it's open
   - أغلق Xcode إذا كان مفتوحاً

2. **Open Terminal** and navigate to project directory
   - افتح Terminal وانتقل إلى مجلد المشروع

3. **Run this command** to add all new files:
   - نفذ هذا الأمر لإضافة جميع الملفات الجديدة:

```bash
cd /Users/soubani/Desktop/KYC-suadi/SaudiOnboardingDemo
open SaudiOnboardingDemo.xcodeproj
```

4. **In Xcode**, select **File > Add Files to "SaudiOnboardingDemo"...**
   - في Xcode، اختر **File > Add Files to "SaudiOnboardingDemo"...**

5. **Navigate and add these folders/files**:
   - انتقل وأضف هذه المجلدات/الملفات:

   - `SaudiOnboardingDemo/Models/MyInvestment.swift`
   - `SaudiOnboardingDemo/ViewModels/MyInvestmentsViewModel.swift`
   - `SaudiOnboardingDemo/Views/MyInvestments/` (entire folder / المجلد بالكامل)

6. **Make sure** "Copy items if needed" is **UNCHECKED** ✅
   - تأكد من أن "Copy items if needed" **غير محدد** ✅

7. **Make sure** "Add to targets: SaudiOnboardingDemo" is **CHECKED** ✅
   - تأكد من أن "Add to targets: SaudiOnboardingDemo" **محدد** ✅

8. **Click "Add"**
   - اضغط على "Add"

9. **Build the project** (⌘ + B)
   - قم ببناء المشروع (⌘ + B)

---

## Option 2: Manual Step-by-Step / الخيار 2: خطوة بخطوة يدوياً

### Step 1: Add MyInvestment Model / إضافة موديل MyInvestment

1. In Xcode **Project Navigator** (left sidebar)
   - في **Project Navigator** في Xcode (الشريط الجانبي الأيسر)

2. Right-click on **"Models"** folder
   - اضغط بالزر الأيمن على مجلد **"Models"**

3. Select **"Add Files to 'SaudiOnboardingDemo'..."**
   - اختر **"Add Files to 'SaudiOnboardingDemo'..."**

4. Navigate to: `SaudiOnboardingDemo/SaudiOnboardingDemo/Models/`
   - انتقل إلى: `SaudiOnboardingDemo/SaudiOnboardingDemo/Models/`

5. Select **MyInvestment.swift**
   - اختر **MyInvestment.swift**

6. ✅ **UNCHECK** "Copy items if needed"
   - ✅ **ألغِ تحديد** "Copy items if needed"

7. ✅ **CHECK** "Add to targets: SaudiOnboardingDemo"
   - ✅ **حدد** "Add to targets: SaudiOnboardingDemo"

8. Click **"Add"**
   - اضغط على **"Add"**

### Step 2: Add MyInvestmentsViewModel / إضافة MyInvestmentsViewModel

1. Right-click on **"ViewModels"** folder
   - اضغط بالزر الأيمن على مجلد **"ViewModels"**

2. Select **"Add Files to 'SaudiOnboardingDemo'..."**
   - اختر **"Add Files to 'SaudiOnboardingDemo'..."**

3. Navigate to: `SaudiOnboardingDemo/SaudiOnboardingDemo/ViewModels/`
   - انتقل إلى: `SaudiOnboardingDemo/SaudiOnboardingDemo/ViewModels/`

4. Select **MyInvestmentsViewModel.swift**
   - اختر **MyInvestmentsViewModel.swift**

5. ✅ **UNCHECK** "Copy items if needed"
   - ✅ **ألغِ تحديد** "Copy items if needed"

6. ✅ **CHECK** "Add to targets: SaudiOnboardingDemo"
   - ✅ **حدد** "Add to targets: SaudiOnboardingDemo"

7. Click **"Add"**
   - اضغط على **"Add"**

### Step 3: Add MyInvestments View Folder / إضافة مجلد MyInvestments View

1. Right-click on **"Views"** folder
   - اضغط بالزر الأيمن على مجلد **"Views"**

2. Select **"Add Files to 'SaudiOnboardingDemo'..."**
   - اختر **"Add Files to 'SaudiOnboardingDemo'..."**

3. Navigate to: `SaudiOnboardingDemo/SaudiOnboardingDemo/Views/`
   - انتقل إلى: `SaudiOnboardingDemo/SaudiOnboardingDemo/Views/`

4. Select **MyInvestments** folder
   - اختر مجلد **MyInvestments**

5. ✅ **UNCHECK** "Copy items if needed"
   - ✅ **ألغِ تحديد** "Copy items if needed"

6. ✅ **CHECK** "Create groups" (not "Create folder references")
   - ✅ **حدد** "Create groups" (وليس "Create folder references")

7. ✅ **CHECK** "Add to targets: SaudiOnboardingDemo"
   - ✅ **حدد** "Add to targets: SaudiOnboardingDemo"

8. Click **"Add"**
   - اضغط على **"Add"**

### Step 4: Build & Run / البناء والتشغيل

1. **Clean Build Folder** (⌘ + Shift + K)
   - **نظف مجلد البناء** (⌘ + Shift + K)

2. **Build** (⌘ + B)
   - **ابنِ المشروع** (⌘ + B)

3. **Run** (⌘ + R)
   - **شغل التطبيق** (⌘ + R)

4. **Navigate to "My Investments" tab** (second tab)
   - **انتقل إلى تاب "استثماراتي"** (التاب الثاني)

---

## Expected Project Structure / البنية المتوقعة للمشروع

After adding files, your Xcode project should look like this:

بعد إضافة الملفات، يجب أن يبدو مشروع Xcode الخاص بك هكذا:

```
SaudiOnboardingDemo/
├── SaudiOnboardingDemo/
│   ├── Models/
│   │   ├── Enums.swift
│   │   ├── InvestmentOpportunity.swift
│   │   ├── MyInvestment.swift ⭐ NEW
│   │   ├── RegistrationData.swift
│   │   ├── SaudiIdOcrResponse.swift
│   │   ├── TimelineItem.swift
│   │   └── Transaction.swift
│   ├── ViewModels/
│   │   ├── MyInvestmentsViewModel.swift ⭐ NEW
│   │   ├── OpportunitiesViewModel.swift
│   │   └── WalletViewModel.swift
│   ├── Views/
│   │   ├── Components/
│   │   ├── Opportunities/
│   │   ├── OpportunityDetail/
│   │   ├── MyInvestments/ ⭐ NEW
│   │   │   └── MyInvestmentsView.swift
│   │   ├── Steps/
│   │   ├── Wallet/
│   │   ├── ContentView.swift
│   │   └── LaunchScreenView.swift
│   ├── Utilities/
│   │   ├── LocalizationManager.swift (updated / محدث)
│   │   ├── ThemeManager.swift
│   │   └── ...
│   └── SaudiOnboardingDemoApp.swift (updated / محدث)
```

---

## Troubleshooting / حل المشاكل

### Problem 1: "Cannot find type 'MyInvestment' in scope"

**Solution / الحل:**
- Make sure `MyInvestment.swift` is added to the target
- تأكد من إضافة `MyInvestment.swift` إلى الـ target
- Check in File Inspector (right sidebar) that "Target Membership" includes "SaudiOnboardingDemo"
- تحقق في File Inspector (الشريط الجانبي الأيمن) أن "Target Membership" يتضمن "SaudiOnboardingDemo"

### Problem 2: "Cannot find 'MyInvestmentsViewModel' in scope"

**Solution / الحل:**
- Make sure `MyInvestmentsViewModel.swift` is added to the target
- تأكد من إضافة `MyInvestmentsViewModel.swift` إلى الـ target
- Clean build folder (⌘ + Shift + K) and rebuild
- نظف مجلد البناء (⌘ + Shift + K) وأعد البناء

### Problem 3: "Cannot find 'MyInvestmentsView' in scope"

**Solution / الحل:**
- Make sure `MyInvestmentsView.swift` is added to the target
- تأكد من إضافة `MyInvestmentsView.swift` إلى الـ target
- Check that the file is in the Build Phases > Compile Sources
- تحقق من أن الملف موجود في Build Phases > Compile Sources

### Problem 4: Build errors

**Solution / الحل:**
1. Clean build folder: **Product > Clean Build Folder** (⌘ + Shift + K)
   - نظف مجلد البناء: **Product > Clean Build Folder** (⌘ + Shift + K)
2. Delete derived data: **Xcode > Preferences > Locations > Derived Data > Delete**
   - احذف derived data: **Xcode > Preferences > Locations > Derived Data > Delete**
3. Restart Xcode
   - أعد تشغيل Xcode
4. Rebuild: **Product > Build** (⌘ + B)
   - أعد البناء: **Product > Build** (⌘ + B)

---

## Verification / التحقق

After building successfully, verify that:

بعد البناء الناجح، تحقق من أن:

✅ No build errors / لا توجد أخطاء بناء
✅ App runs without crashes / التطبيق يعمل بدون أعطال
✅ Bottom navigation bar shows 4 tabs / شريط التنقل السفلي يعرض 4 تابات
✅ Second tab shows "My Investments" page / التاب الثاني يعرض صفحة "استثماراتي"
✅ All text is properly localized / جميع النصوص مترجمة بشكل صحيح
✅ Currency symbols display correctly / رموز العملة تعرض بشكل صحيح
✅ Theme switching works / تبديل الثيم يعمل
✅ Language switching works / تبديل اللغة يعمل

---

## Quick Test / اختبار سريع

1. **Launch the app** / شغل التطبيق
2. **Tap the second tab** (chart icon) / اضغط على التاب الثاني (أيقونة الرسم البياني)
3. **You should see**:
   - يجب أن ترى:
   - Page title "استثماراتي" or "My Investments"
   - Total investment card with dark gradient
   - Three statistics cards
   - Two investment cards with images
4. **Go to Profile tab** / اذهب إلى تاب الملف الشخصي
5. **Switch language** / بدل اللغة
6. **Go back to My Investments** / ارجع إلى استثماراتي
7. **Verify all text changed** / تحقق من تغيير جميع النصوص
8. **Switch theme** (Dark/Light) / بدل الثيم (داكن/فاتح)
9. **Verify colors updated** / تحقق من تحديث الألوان

---

## Support / الدعم

If you encounter any issues:
- إذا واجهت أي مشاكل:

1. Check the console for error messages
   - تحقق من الـ console للرسائل الخطأ
2. Verify all files are in the correct locations
   - تحقق من أن جميع الملفات في المواقع الصحيحة
3. Ensure all files are added to the target
   - تأكد من إضافة جميع الملفات إلى الـ target
4. Review the documentation files:
   - راجع ملفات التوثيق:
   - `MY_INVESTMENTS_README.md`
   - `دليل_صفحة_استثماراتي.md`

---

**Good luck! / حظاً موفقاً!** 🚀

**Created: January 12, 2026**  
**تاريخ الإنشاء: ١٢ يناير ٢٠٢٦**
