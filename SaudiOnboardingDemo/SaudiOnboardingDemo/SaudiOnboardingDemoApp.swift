//
//  SaudiOnboardingDemoApp.swift
//  SaudiOnboardingDemo
//
//  Created on 2026
//

import SwiftUI
import Foundation
import Combine

@main
struct SaudiOnboardingDemoApp: App {
    @StateObject private var localizationManager = LocalizationManager.shared
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
                .environmentObject(localizationManager)
                .environmentObject(themeManager)
                .environment(\.layoutDirection, localizationManager.currentLanguage.isRTL ? .rightToLeft : .leftToRight)
                .preferredColorScheme(themeManager.currentTheme == .light ? .light : themeManager.currentTheme == .dark ? .dark : nil)
        }
    }
}

// MARK: - Root Tab View
struct RootTabView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var selectedTab: Int = 0
    @State private var hideTabBar: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case 0:
                    NavigationView {
                        OpportunitiesViewWithTabControl(hideTabBar: $hideTabBar)
                    }
                    .navigationViewStyle(.stack)
                case 1:
                    MyInvestmentsView()
                case 2:
                    WalletView()
                case 3:
                    ProfilePlaceholderView()
                default:
                    NavigationView {
                        OpportunitiesViewWithTabControl(hideTabBar: $hideTabBar)
                    }
                    .navigationViewStyle(.stack)
                }
            }
            
            if !hideTabBar {
                BottomNavigationBar(selectedTab: $selectedTab)
            }
        }
    }
}

// MARK: - Opportunities View with Tab Control
struct OpportunitiesViewWithTabControl: View {
    @Binding var hideTabBar: Bool
    
    var body: some View {
        OpportunitiesViewContent(hideTabBar: $hideTabBar)
            .onAppear {
                hideTabBar = false
            }
    }
}

struct OpportunitiesViewContent: View {
    @StateObject private var viewModel = OpportunitiesViewModel()
    @Binding var hideTabBar: Bool
    private let gutter: CGFloat = 20

    // Scroll tracking
    @State private var scrollMinY: CGFloat = 0

    // Tuning
    private let headerCollapseDistance: CGFloat = 120
    private let searchCollapseDistance: CGFloat = 80

    private var scrollY: CGFloat { max(0, -scrollMinY) }

    private var headerProgress: CGFloat {
        min(scrollY / headerCollapseDistance, 1)
    }

    private var searchProgress: CGFloat {
        min(scrollY / searchCollapseDistance, 1)
    }

    private var headerHidden: Bool { headerProgress >= 1 }
    private var searchHidden: Bool { searchProgress >= 1 }
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    Color.clear
                        .frame(height: 1)
                        .background(
                            GeometryReader { geo in
                                Color.clear.preference(
                                    key: ScrollMinYPreferenceKey.self,
                                    value: geo.frame(in: .named("opportunitiesScroll")).minY
                                )
                            }
                        )

                    // Header content that collapses & disappears
                    VStack(spacing: 0) {
                        headerSection
                            .opacity(1 - headerProgress)

                        // Search bar that collapses & disappears
                        searchBarSection
                            .opacity(1 - searchProgress)
                            .allowsHitTesting(!searchHidden)
                    }
                    .background(Color(UIColor.systemBackground))

                    // Section with pinned filters
                    Section {
                        opportunitiesListContent
                            .background(Color(UIColor.systemGroupedBackground))
                    } header: {
                        filterSectionPinned
                            .background(Color(UIColor.systemBackground))
                            .compositingGroup()
                            .zIndex(2)
                    }
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
            .coordinateSpace(name: "opportunitiesScroll")
            .onPreferenceChange(ScrollMinYPreferenceKey.self) { value in
                scrollMinY = value
            }

            // Solid white cover for the top safe area above the pinned filter
            GeometryReader { proxy in
                Color(UIColor.systemBackground)
                    .frame(height: proxy.safeAreaInsets.top)
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea(edges: .top)
                    .allowsHitTesting(false)
            }
            .frame(height: 0)
        }
        .navigationBarHidden(true)
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedStrings.get("opportunities.title"))
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(LocalizedStrings.get("opportunities.subtitle"))
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 20))
                    .foregroundColor(.primary)
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.horizontal, gutter)
        .padding(.top, 16)
        .padding(.bottom, 12)
        .background(Color(UIColor.systemBackground))
    }
    
    private var searchBarSection: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .font(.system(size: 18))
            
            TextField(LocalizedStrings.get("opportunities.search"), text: $viewModel.searchText)
                .font(.system(size: 16))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal, gutter)
        .padding(.bottom, 16)
        .background(Color(UIColor.systemBackground))
    }
    
    private var filterSectionPinned: some View {
        ZStack {
            // Solid white background to fully cover content behind
            Color(UIColor.systemBackground)
                .frame(maxWidth: .infinity, minHeight: 56)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(PropertyType.allCases) { type in
                        FilterButton(
                            title: type.displayName,
                            isSelected: viewModel.selectedFilter == type
                        ) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                viewModel.selectFilter(type)
                            }
                        }
                    }
                }
                .padding(.horizontal, gutter)
            }
            .padding(.vertical, 12)
        }
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemBackground))
        .compositingGroup()
        .overlay(
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 0.5),
            alignment: .bottom
        )
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private var opportunitiesListContent: some View {
        LazyVStack(spacing: 20) {
            ForEach(viewModel.filteredOpportunities) { opportunity in
                NavigationLink(
                    destination: OpportunityDetailView(opportunity: opportunity, hideTabBar: $hideTabBar)
                ) {
                    OpportunityCard(opportunity: opportunity)
                }
                .buttonStyle(.plain)
                .padding(.horizontal, gutter)
                .simultaneousGesture(TapGesture().onEnded {
                    withAnimation {
                        hideTabBar = true
                    }
                })
            }
        }
        .padding(.vertical, 20)
    }
}

private struct ScrollMinYPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Transaction Type
enum TransactionType {
    case topUp, investment, dividend, withdrawal
    
    var iconName: String {
        switch self {
        case .topUp: return "arrow.down.left"
        case .investment: return "arrow.up.right"
        case .dividend: return "banknote"
        case .withdrawal: return "arrow.up.right"
        }
    }
}

// MARK: - Transaction Status
enum TransactionStatus: String {
    case completed = "Completed"
    case processing = "Processing"
    
    var localizedString: String {
        switch self {
        case .completed:
            return LocalizedStrings.get("status.completed")
        case .processing:
            return LocalizedStrings.get("status.processing")
        }
    }
}

// MARK: - Transaction Model
struct Transaction: Identifiable {
    let id = UUID()
    let title: String
    let amount: Double
    let date: Date
    let type: TransactionType
    let status: TransactionStatus
    
    var formattedAmount: String {
        let prefix = amount >= 0 ? "+" : "-"
        return "\(prefix) \(String(format: "%.0f", abs(amount)))"
    }
    
    var amountColor: Color {
        return amount >= 0 ? .orange : .primary
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            formatter.dateFormat = "h:mm a"
            return "\(LocalizedStrings.get("date.today")), \(formatter.string(from: date))"
        } else if calendar.isDateInYesterday(date) {
            formatter.dateFormat = "h:mm a"
            return "\(LocalizedStrings.get("date.yesterday")), \(formatter.string(from: date))"
        } else {
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: date)
        }
    }
}

// MARK: - Wallet ViewModel
class WalletViewModel: ObservableObject {
    @Published var totalBalance: Double = 124500.00
    @Published var availableToInvest: Double = 24500.00
    @Published var totalInvested: Double = 100000.00
    @Published var transactions: [Transaction] = []
    
    init() {
        loadWalletData()
    }
    
    func loadWalletData() {
        let now = Date()
        let calendar = Calendar.current
        
        transactions = [
            Transaction(
                title: LocalizedStrings.get("transaction.topUp"),
                amount: 5000,
                date: now,
                type: .topUp,
                status: .completed
            ),
            Transaction(
                title: LocalizedStrings.get("transaction.investment"),
                amount: -25000,
                date: calendar.date(byAdding: .day, value: -1, to: now)!,
                type: .investment,
                status: .completed
            ),
            Transaction(
                title: LocalizedStrings.get("transaction.dividend"),
                amount: 1250,
                date: calendar.date(byAdding: .day, value: -7, to: now)!,
                type: .dividend,
                status: .completed
            ),
            Transaction(
                title: LocalizedStrings.get("transaction.withdrawal"),
                amount: -10000,
                date: calendar.date(byAdding: .day, value: -8, to: now)!,
                type: .withdrawal,
                status: .processing
            )
        ]
    }
    
    func topUp() { print("Top Up") }
    func withdraw() { print("Withdraw") }
}

// MARK: - Wallet View
struct WalletView: View {
    @StateObject private var viewModel = WalletViewModel()
    private let gutter: CGFloat = 20
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                headerSection
                balanceCard
                statsCards
                transactionsSection
            }
            .padding(.horizontal, gutter)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    private var headerSection: some View {
        HStack {
            Text(LocalizedStrings.get("wallet.title"))
                .font(.system(size: 32, weight: .bold))
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 22))
                    .foregroundColor(.primary)
            }
        }
    }
    
    private var balanceCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text(LocalizedStrings.get("wallet.totalBalance"))
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                
                CurrencyText(
                    amount: String(format: "%.2f", viewModel.totalBalance),
                    amountSize: 48,
                    logoSize: 36,
                    color: .white,
                    weight: .bold
                )
            }
            
            HStack(spacing: 12) {
                Button(action: viewModel.topUp) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .bold))
                        Text(LocalizedStrings.get("wallet.topUp"))
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [Color(red: 0.85, green: 0.75, blue: 0.45), Color(red: 0.75, green: 0.65, blue: 0.35)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(12)
                }
                
                Button(action: viewModel.withdraw) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.down.left")
                            .font(.system(size: 16, weight: .bold))
                        Text(LocalizedStrings.get("wallet.withdraw"))
                            .font(.system(size: 16, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(white: 0.25))
                    .cornerRadius(12)
                }
            }
        }
        .padding(24)
        .background(
            LinearGradient(
                colors: [Color(white: 0.15), Color(white: 0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 8)
    }
    
    private var statsCards: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(LocalizedStrings.get("wallet.availableToInvest"))
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
                CurrencyText(
                    amount: String(format: "%.0f", viewModel.availableToInvest),
                    amountSize: 22,
                    logoSize: 18,
                    color: .primary,
                    weight: .bold
                )
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(LocalizedStrings.get("wallet.totalInvested"))
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
                CurrencyText(
                    amount: String(format: "%.0f", viewModel.totalInvested),
                    amountSize: 22,
                    logoSize: 18,
                    color: .primary,
                    weight: .bold
                )
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }
    
    private var transactionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(LocalizedStrings.get("wallet.recentTransactions"))
                .font(.system(size: 22, weight: .bold))
            
            VStack(spacing: 0) {
                ForEach(viewModel.transactions) { transaction in
                    TransactionRow(transaction: transaction)
                    if transaction.id != viewModel.transactions.last?.id {
                        Divider().padding(.leading, 60)
                    }
                }
            }
            .background(Color(UIColor.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }
}

// MARK: - Transaction Row
struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(iconBackgroundColor)
                    .frame(width: 44, height: 44)
                Image(systemName: transaction.type.iconName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .font(.system(size: 15, weight: .semibold))
                Text(transaction.formattedDate)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                CurrencyText(
                    amount: transaction.formattedAmount,
                    amountSize: 16,
                    logoSize: 14,
                    color: transaction.amountColor,
                    weight: .bold
                )
                Text(transaction.status.localizedString)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
    
    private var iconBackgroundColor: Color {
        switch transaction.type {
        case .topUp: return Color(UIColor.systemGray5)
        case .investment: return Color.black
        case .dividend: return Color.orange.opacity(0.15)
        case .withdrawal: return Color(UIColor.systemGray5)
        }
    }
    
    private var iconColor: Color {
        switch transaction.type {
        case .topUp: return .primary
        case .investment: return .white
        case .dividend: return .orange
        case .withdrawal: return .primary
        }
    }
}

// MARK: - Profile View
struct ProfilePlaceholderView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @EnvironmentObject var themeManager: ThemeManager
    private let gutter: CGFloat = 20
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Profile Header
                profileHeader
                
                // Language Switcher Button (Added at top)
                languageSwitcherButton
                
                // Theme Switcher Button (Dark Mode)
                themeSwitcherButton
                
                // Account Verified Banner
                verifiedBanner
                
                // Account Settings
                settingsSection(
                    title: LocalizedStrings.get("profile.accountSettings"),
                    items: [
                        ("person", LocalizedStrings.get("profile.personalInfo"), nil),
                        ("bell", LocalizedStrings.get("profile.notifications"), nil),
                        ("gearshape", LocalizedStrings.get("profile.preferences"), nil)
                    ]
                )
                
                // Financial
                settingsSection(
                    title: LocalizedStrings.get("profile.financial"),
                    items: [
                        ("creditcard", LocalizedStrings.get("profile.paymentMethods"), nil),
                        ("doc.text", LocalizedStrings.get("profile.documents"), nil),
                        ("doc.text", LocalizedStrings.get("profile.taxReports"), nil)
                    ]
                )
                
                // Support & Legal
                settingsSection(
                    title: LocalizedStrings.get("profile.supportLegal"),
                    items: [
                        ("questionmark.circle", LocalizedStrings.get("profile.helpCenter"), nil),
                        ("doc.text", LocalizedStrings.get("profile.terms"), nil),
                        ("doc.text", LocalizedStrings.get("profile.privacy"), nil)
                    ]
                )
                
                // Log Out Button
                logOutButton
            }
            .padding(.horizontal, gutter)
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    private var profileHeader: some View {
        VStack(spacing: 16) {
            // Profile Image
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color(UIColor.systemGray5))
                    .frame(width: 100, height: 100)
                
                // Verified Badge
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 24))
                        .foregroundColor(Color(red: 0.85, green: 0.75, blue: 0.45))
                }
                .offset(x: 4, y: 4)
            }
            
            // Name and Email
            VStack(spacing: 6) {
                Text(LocalizedStrings.get("profile.name"))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                
                HStack(spacing: 8) {
                    Text(LocalizedStrings.get("profile.email"))
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    
                    Text(LocalizedStrings.get("profile.accredited"))
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color(red: 0.65, green: 0.55, blue: 0.25))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(red: 0.95, green: 0.90, blue: 0.70))
                        .cornerRadius(4)
                }
            }
        }
        .padding(.vertical, 20)
    }
    
    private var languageSwitcherButton: some View {
        Button(action: {
            localizationManager.toggleLanguage()
        }) {
            HStack(spacing: 12) {
                Image(systemName: "globe")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(LocalizedStrings.get("profile.language"))
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(localizationManager.currentLanguage.displayName)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(16)
            .background(
                LinearGradient(
                    colors: [Color(red: 0.85, green: 0.75, blue: 0.45), Color(red: 0.75, green: 0.65, blue: 0.35)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(16)
            .shadow(color: Color.primary.opacity(0.2), radius: 8, x: 0, y: 4)
        }
    }
    
    private var themeSwitcherButton: some View {
        Button(action: {
            themeManager.toggleTheme()
        }) {
            HStack(spacing: 12) {
                Image(systemName: themeManager.currentTheme.icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(LocalizedStrings.get("theme.title"))
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(themeManager.currentTheme.displayName)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                Image(systemName: themeManager.currentTheme == .dark ? "moon.fill" : "sun.max.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(16)
            .background(
                LinearGradient(
                    colors: themeManager.currentTheme == .dark ?
                        [Color(red: 0.2, green: 0.2, blue: 0.3), Color(red: 0.1, green: 0.1, blue: 0.2)] :
                        [Color(red: 0.3, green: 0.5, blue: 0.9), Color(red: 0.2, green: 0.4, blue: 0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(16)
            .shadow(color: Color.primary.opacity(0.2), radius: 8, x: 0, y: 4)
        }
    }
    
    private var verifiedBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.shield.fill")
                .font(.system(size: 24))
                .foregroundColor(Color(red: 0.85, green: 0.75, blue: 0.45))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedStrings.get("profile.verified"))
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(LocalizedStrings.get("profile.verifiedDesc"))
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color(red: 1.0, green: 0.98, blue: 0.88))
        .cornerRadius(12)
    }
    
    private func settingsSection(title: String, items: [(icon: String, title: String, trailing: String?)]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary)
                .tracking(0.5)
            
            VStack(spacing: 0) {
                ForEach(items.indices, id: \.self) { index in
                    settingsRow(
                        icon: items[index].icon,
                        title: items[index].title,
                        trailing: items[index].trailing
                    )
                    
                    if index < items.count - 1 {
                        Divider()
                            .padding(.leading, 44)
                    }
                }
            }
            .background(Color(UIColor.systemBackground))
            .cornerRadius(12)
        }
    }
    
    private func settingsRow(icon: String, title: String, trailing: String?) -> some View {
        Button(action: {}) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.primary)
                    .frame(width: 24)
                
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.primary)
                
                Spacer()
                
                if let trailing = trailing {
                    Text(trailing)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
    }
    
    private var logOutButton: some View {
        Button(action: {}) {
            HStack(spacing: 8) {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 18, weight: .semibold))
                
                Text(LocalizedStrings.get("profile.logout"))
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.red)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
        }
        .padding(.top, 20)
    }
}
