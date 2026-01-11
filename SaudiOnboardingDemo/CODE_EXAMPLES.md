# 💻 أمثلة على الكود - Code Examples

## 📋 كيفية استخدام المكونات

---

## 1️⃣ إضافة فرصة استثمارية جديدة

### في ملف `Models/InvestmentOpportunity.swift`:

```swift
// أضف في mockData array:
InvestmentOpportunity(
    title: "Makkah Royal Towers",
    location: "Abraj Al Bait, Makkah",
    type: .commercial,
    imageName: "makkah_towers", // تأكد من إضافة الصورة في Assets
    returnRate: 8.5,
    yieldRate: 7.2,
    minInvestment: 10000,
    fundedPercentage: 35,
    targetAmount: 100.0,
    status: .active
)
```

---

## 2️⃣ إضافة فرصة "Coming Soon"

```swift
InvestmentOpportunity(
    title: "Neom Smart City Phase 1",
    location: "Neom, Tabuk",
    type: .industrial,
    imageName: "neom_city",
    returnRate: 12.0,
    yieldRate: 10.5,
    minInvestment: 15000,
    fundedPercentage: 0,
    targetAmount: 500.0,
    status: .comingSoon,
    comingSoonDays: 7  // سيفتح بعد 7 أيام
)
```

---

## 3️⃣ استخدام OpportunitiesView في صفحة أخرى

```swift
import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            OpportunitiesView()
                .tabItem {
                    Label("Invest", systemImage: "house.fill")
                }
                .tag(0)
            
            WalletView()
                .tabItem {
                    Label("Wallet", systemImage: "wallet.pass.fill")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(2)
        }
    }
}
```

---

## 4️⃣ استخدام OpportunityCard بشكل مستقل

```swift
import SwiftUI

struct MyCustomView: View {
    let opportunity = InvestmentOpportunity(
        title: "Test Property",
        location: "Riyadh",
        type: .residential,
        imageName: "test_image",
        returnRate: 7.0,
        yieldRate: 6.0,
        minInvestment: 5000,
        fundedPercentage: 50,
        targetAmount: 20.0
    )
    
    var body: some View {
        ScrollView {
            OpportunityCard(opportunity: opportunity)
                .padding()
        }
    }
}
```

---

## 5️⃣ تخصيص ViewModel

```swift
import SwiftUI

struct CustomOpportunitiesView: View {
    @StateObject private var viewModel = OpportunitiesViewModel()
    
    var body: some View {
        VStack {
            // عرض عدد النتائج
            Text("Found \(viewModel.filteredOpportunities.count) opportunities")
                .font(.headline)
                .padding()
            
            // عرض البطاقات
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.filteredOpportunities) { opportunity in
                        OpportunityCard(opportunity: opportunity)
                            .onTapGesture {
                                // الانتقال لصفحة التفاصيل
                                print("Tapped: \(opportunity.title)")
                            }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            // تحميل البيانات عند ظهور الصفحة
            viewModel.loadOpportunities()
        }
    }
}
```

---

## 6️⃣ إضافة فلتر مخصص

```swift
// في OpportunitiesViewModel.swift

// أضف property جديدة:
@Published var minReturnRate: Double = 0.0

// عدّل filterOpportunities:
private func filterOpportunities(
    opportunities: [InvestmentOpportunity],
    filter: PropertyType,
    searchText: String
) -> [InvestmentOpportunity] {
    var filtered = opportunities
    
    // Filter by type
    if filter != .all {
        filtered = filtered.filter { $0.type == filter }
    }
    
    // Filter by search
    if !searchText.isEmpty {
        filtered = filtered.filter { opportunity in
            opportunity.title.localizedCaseInsensitiveContains(searchText) ||
            opportunity.location.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    // NEW: Filter by minimum return rate
    if minReturnRate > 0 {
        filtered = filtered.filter { $0.returnRate >= minReturnRate }
    }
    
    return filtered
}
```

---

## 7️⃣ إضافة Navigation لصفحة التفاصيل

```swift
struct OpportunitiesView: View {
    @StateObject private var viewModel = OpportunitiesViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.filteredOpportunities) { opportunity in
                        NavigationLink(destination: OpportunityDetailView(opportunity: opportunity)) {
                            OpportunityCard(opportunity: opportunity)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .navigationTitle("Opportunities")
        }
    }
}

// صفحة التفاصيل (مثال)
struct OpportunityDetailView: View {
    let opportunity: InvestmentOpportunity
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // صورة كبيرة
                Image(opportunity.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)
                    .clipped()
                
                VStack(alignment: .leading, spacing: 16) {
                    Text(opportunity.title)
                        .font(.title)
                        .bold()
                    
                    Text(opportunity.location)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // المزيد من التفاصيل...
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
```

---

## 8️⃣ إضافة Sorting

```swift
// في OpportunitiesViewModel.swift

enum SortOption: String, CaseIterable {
    case returnRate = "Highest Return"
    case yieldRate = "Highest Yield"
    case fundedPercentage = "Most Funded"
    case newest = "Newest"
}

@Published var sortOption: SortOption = .returnRate

private func sortOpportunities(_ opportunities: [InvestmentOpportunity]) -> [InvestmentOpportunity] {
    switch sortOption {
    case .returnRate:
        return opportunities.sorted { $0.returnRate > $1.returnRate }
    case .yieldRate:
        return opportunities.sorted { $0.yieldRate > $1.yieldRate }
    case .fundedPercentage:
        return opportunities.sorted { $0.fundedPercentage > $1.fundedPercentage }
    case .newest:
        return opportunities // أو حسب تاريخ الإضافة
    }
}
```

---

## 9️⃣ إضافة Favorites

```swift
// في OpportunitiesViewModel.swift

@Published var favoriteIds: Set<UUID> = []

func toggleFavorite(_ opportunity: InvestmentOpportunity) {
    if favoriteIds.contains(opportunity.id) {
        favoriteIds.remove(opportunity.id)
    } else {
        favoriteIds.insert(opportunity.id)
    }
}

func isFavorite(_ opportunity: InvestmentOpportunity) -> Bool {
    return favoriteIds.contains(opportunity.id)
}

// في OpportunityCard.swift - أضف زر القلب:
Button(action: {
    viewModel.toggleFavorite(opportunity)
}) {
    Image(systemName: viewModel.isFavorite(opportunity) ? "heart.fill" : "heart")
        .foregroundColor(.red)
}
```

---

## 🔟 ربط API حقيقي

```swift
// في OpportunitiesViewModel.swift

func loadOpportunities() {
    isLoading = true
    
    // استبدل Mock Data بـ API call
    let url = URL(string: "https://api.example.com/opportunities")!
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        DispatchQueue.main.async {
            self.isLoading = false
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    self.opportunities = try decoder.decode([InvestmentOpportunity].self, from: data)
                } catch {
                    print("Error decoding: \(error)")
                    // Fallback to mock data
                    self.opportunities = InvestmentOpportunity.mockData
                }
            }
        }
    }.resume()
}
```

---

## 1️⃣1️⃣ إضافة Pull to Refresh

```swift
struct OpportunitiesView: View {
    @StateObject private var viewModel = OpportunitiesViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(viewModel.filteredOpportunities) { opportunity in
                    OpportunityCard(opportunity: opportunity)
                }
            }
            .padding()
        }
        .refreshable {
            await viewModel.refreshOpportunities()
        }
    }
}

// في ViewModel:
func refreshOpportunities() async {
    isLoading = true
    // محاكاة تحميل البيانات
    try? await Task.sleep(nanoseconds: 1_000_000_000)
    loadOpportunities()
}
```

---

## 1️⃣2️⃣ إضافة Animation عند الظهور

```swift
struct OpportunityCard: View {
    let opportunity: InvestmentOpportunity
    @State private var isVisible = false
    
    var body: some View {
        VStack {
            // ... محتوى البطاقة
        }
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 50)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                isVisible = true
            }
        }
    }
}
```

---

## 📝 ملاحظات مهمة

### ✅ Best Practices:
1. استخدم `@StateObject` للـ ViewModel في الـ View الأساسية
2. استخدم `@ObservedObject` عند تمرير ViewModel للـ child views
3. استخدم `LazyVStack` للقوائم الطويلة
4. استخدم `async/await` للـ API calls
5. احتفظ بـ Mock Data للتطوير والاختبار

### ⚠️ تجنب:
1. لا تضع logic في الـ Views
2. لا تستخدم `@State` للـ complex objects
3. لا تنسى `[weak self]` في الـ closures
4. لا تحمّل البيانات في `init()`

---

## 🎯 الخلاصة

هذه الأمثلة توضح كيفية:
- ✅ إضافة بيانات جديدة
- ✅ تخصيص المكونات
- ✅ إضافة features جديدة
- ✅ ربط API
- ✅ تحسين UX

**الكود مرن وقابل للتوسع!** 🚀

---

للمزيد من الأمثلة، راجع:
- `OPPORTUNITIES_README.md` - توثيق تقني
- `تعليمات_الاستخدام.md` - دليل المستخدم
- الكود نفسه - مع تعليقات توضيحية
