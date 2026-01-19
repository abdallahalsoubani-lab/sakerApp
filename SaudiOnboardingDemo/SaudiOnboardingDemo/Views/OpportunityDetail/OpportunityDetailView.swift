//
//  OpportunityDetailView.swift
//  SaudiOnboardingDemo
//
//  Created on 2026-01-11
//

import SwiftUI
import UIKit

// MARK: - Opportunity Detail View
struct OpportunityDetailView: View {

    // MARK: - Properties
    let opportunity: InvestmentOpportunity
    @Binding var hideTabBar: Bool
    @Environment(\.presentationMode) var presentationMode

    @State private var investmentAmount: Double = 26000
    @State private var showingCalculator = false

    // Scroll tracking (to shrink sticky bars)
    @State private var scrollOffsetY: CGFloat = 0

    // MARK: - Debug
    private let debugLogsEnabled: Bool = true
    private func log(_ message: String) {
        guard debugLogsEnabled else { return }
        print("🧩 [OpportunityDetailView] \(message)")
    }

    // MARK: - Tuning
    private let heroMinHeight: CGFloat = 170
    private let bottomBarCompactAfter: CGFloat = 80

    private var scrollY: CGFloat { max(CGFloat(0), scrollOffsetY) }

    private var heroMaxHeight: CGFloat {
        ResponsiveLayout.heroImageHeight
    }

    private var heroCollapseRange: CGFloat {
        max(CGFloat(1), heroMaxHeight - heroMinHeight)
    }

    private var heroHeight: CGFloat {
        max(heroMinHeight, heroMaxHeight - scrollY)
    }

    private var heroProgress: CGFloat {
        min(scrollY / heroCollapseRange, CGFloat(1))
    }

    private var shouldCompactBottomBar: Bool {
        scrollY >= bottomBarCompactAfter
    }

    // MARK: - Computed Properties
    private var projectedValue: Double {
        investmentAmount * (1 + opportunity.returnRate / 100)
    }

    private var annualIncome: Double {
        investmentAmount * (opportunity.yieldRate / 100)
    }

    private var appreciation: Double {
        projectedValue - investmentAmount
    }

    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            let topInset = geometry.safeAreaInsets.top

            ZStack(alignment: .top) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        // Hero Image Section (shrinks on scroll)
                        heroSection
                            .frame(width: geometry.size.width)
                            .frame(height: heroHeight)
                            .clipped()
                            .onAppear { log("heroSection appeared") }

                        // Content Sections
                        VStack(spacing: ResponsiveLayout.sectionSpacing) {
                            statsSection
                            fundingProgressSection
                            viewersSection
                            calculatorCard
                            timelineSection
                            dueDiligenceSection
                            documentsSection
                        }
                        .frame(maxWidth: geometry.size.width)
                        .responsivePadding()
                        .padding(.top, ResponsiveLayout.sectionSpacing)
                        .padding(.bottom, ResponsiveLayout.largeSpacing * 2)
                        .onAppear { log("content sections appeared") }
                    }
                    .frame(maxWidth: geometry.size.width)
                }
                .ignoresSafeArea(edges: .top)
                .onAppear {
                    log("ScrollView appeared")
                }
                .onChange(of: scrollOffsetY) { newValue in
                    // This can print a lot while scrolling.
                    log("scrollOffsetY -> \(newValue)")
                }
                .overlay(alignment: .topLeading) {
                    // Detect UIScrollView contentOffset
                    ScrollViewOffsetDetector(tag: "OpportunityDetailView", debug: debugLogsEnabled) { y in
                        scrollOffsetY = y
                        if debugLogsEnabled {
                            print("🧭 [DetailOffsetDetector] callback y=\(y)")
                        }
                    }
                    .frame(width: 1, height: 1)
                    .allowsHitTesting(false)
                }

                // Custom Navigation Bar (adds background when hero collapses)
                customNavBar(topInset: topInset)
                    .frame(width: geometry.size.width)
                    .onAppear { log("customNavBar appeared") }
            }
            .navigationBarHidden(true)
            .safeAreaInset(edge: .bottom) {
                bottomActionBar(isCompact: shouldCompactBottomBar)
                    .frame(width: geometry.size.width)
                    .onAppear { log("bottomActionBar appeared") }
            }
        }
        .onAppear {
            hideTabBar = true
            log("OpportunityDetailView onAppear (hideTabBar = true)")
        }
        .onDisappear {
            hideTabBar = false
            log("OpportunityDetailView onDisappear (hideTabBar = false)")
        }
    }

    // MARK: - Hero Section (shrinks on scroll)
    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            // Background Image
            Image(opportunity.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.black.opacity(0.65),
                            Color.black.opacity(0.30),
                            Color.clear
                        ]),
                        startPoint: .bottom,
                        endPoint: .center
                    )
                )

            // LIVE FUNDING Badge
            if opportunity.status == .active {
                VStack {
                    HStack {
                        Spacer()
                        HStack(spacing: 6) {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 6, height: 6)
                            Text(LocalizedStrings.get("status.active"))
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.primary)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white.cornerRadius(16))
                    }
                    .padding(.trailing, 40)
                    Spacer()
                }
                .padding(.top, 60)
                .opacity(max(CGFloat(0), CGFloat(1) - heroProgress * 1.2))
            }

            // Title + Location (fade out as hero collapses)
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(opportunity.title)
                        .font(.system(size: ResponsiveLayout.titleSize, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.leading, ResponsiveLayout.horizontalPadding)

                    HStack(spacing: ResponsiveLayout.smallSpacing) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: ResponsiveLayout.captionSize))
                        Text(opportunity.location)
                            .font(.system(size: ResponsiveLayout.captionSize, weight: .medium))
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                            .padding(.leading, ResponsiveLayout.horizontalPadding)
                    }
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal, ResponsiveLayout.horizontalPadding)
            .padding(.bottom, ResponsiveLayout.baseSpacing)
            .opacity(max(CGFloat(0), CGFloat(1) - heroProgress * 1.25))
            .scaleEffect(CGFloat(1) - (heroProgress * 0.05), anchor: .leading)
        }
        // Keep max height here; actual visible height set in body via .frame(height: heroHeight)
        .frame(height: heroMaxHeight)
    }

    // MARK: - Stats Section
    private var statsSection: some View {
        HStack(spacing: 0) {
            VStack(spacing: ResponsiveLayout.smallSpacing) {
                Text(LocalizedStrings.get("detail.annualReturn"))
                    .font(.system(size: ResponsiveLayout.captionSize - 2, weight: .semibold))
                    .foregroundColor(.secondary)
                    .tracking(0.5)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)

                Text(String(format: "%.2f%%", opportunity.returnRate))
                    .font(.system(size: ResponsiveLayout.titleSize + 2, weight: .bold))
                    .foregroundColor(.orange)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)

            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 1, height: ResponsiveLayout.iconSize)

            VStack(spacing: ResponsiveLayout.smallSpacing) {
                Text(LocalizedStrings.get("detail.distribution"))
                    .font(.system(size: ResponsiveLayout.captionSize - 2, weight: .semibold))
                    .foregroundColor(.secondary)
                    .tracking(0.5)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)

                Text(LocalizedStrings.get("detail.monthly"))
                    .font(.system(size: ResponsiveLayout.subtitleSize, weight: .bold))
                    .foregroundColor(.primary)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)

            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 1, height: ResponsiveLayout.iconSize)

            VStack(spacing: ResponsiveLayout.smallSpacing) {
                Text(LocalizedStrings.get("detail.term"))
                    .font(.system(size: ResponsiveLayout.captionSize - 2, weight: .semibold))
                    .foregroundColor(.secondary)
                    .tracking(0.5)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)

                Text(LocalizedStrings.get("detail.years"))
                    .font(.system(size: ResponsiveLayout.subtitleSize, weight: .bold))
                    .foregroundColor(.primary)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, ResponsiveLayout.baseSpacing)
    }

    // MARK: - Funding Progress Section
    private var fundingProgressSection: some View {
        VStack(alignment: .leading, spacing: ResponsiveLayout.baseSpacing) {
            HStack {
                Text(LocalizedStrings.get("detail.fundingProgress"))
                    .font(.system(size: ResponsiveLayout.subtitleSize, weight: .bold))
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)

                Spacer()

                Text("\(Int(100 - opportunity.fundedPercentage))\(LocalizedStrings.get("detail.available"))")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(Color.black.cornerRadius(14))
            }

            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 12)

                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.orange.opacity(0.9),
                                    Color.orange
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(
                            width: geometry.size.width * CGFloat(opportunity.fundedPercentage / 100),
                            height: 12
                        )
                }
            }
            .frame(height: 12)

            HStack {
                HStack(spacing: 4) {
                    Text(LocalizedStrings.get("card.funded") + ": " + String(format: "%.1fM", opportunity.targetAmount * opportunity.fundedPercentage / 100))
                        .font(.system(size: 12, weight: .semibold))
                    CurrencyView(size: 10, color: .primary)
                }

                Spacer(minLength: 8)

                HStack(spacing: 4) {
                    Text(LocalizedStrings.get("card.target") + ": " + String(format: "%.0f,000,000", opportunity.targetAmount))
                        .font(.system(size: 12, weight: .semibold))
                    CurrencyView(size: 10, color: .primary)
                }
            }
            .foregroundColor(.primary)
        }
    }

    // MARK: - Viewers Section
    private var viewersSection: some View {
        HStack(spacing: 12) {
            HStack(spacing: -8) {
                ForEach(0..<3) { _ in
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 32, height: 32)
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                }
            }

            HStack(spacing: 4) {
                Image(systemName: "eye")
                    .font(.system(size: 14))
                Text("241 \(LocalizedStrings.get("detail.viewers"))")
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundColor(.secondary)

            Spacer()
        }
        .padding(16)
        .background(Color(UIColor.secondarySystemBackground).cornerRadius(16))
    }

    // MARK: - Calculator Card
    private var calculatorCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                CurrencyText(
                    amount: String(format: "%.0f", projectedValue),
                    amountSize: 36,
                    logoSize: 28,
                    color: .primary,
                    weight: .bold
                )

                Spacer()

                HStack(spacing: 4) {
                    Text("+\(String(format: "%.2f%%", opportunity.returnRate))")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.orange)
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.orange)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(Color.orange.opacity(0.1).cornerRadius(6))
            }

            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(LocalizedStrings.get("detail.annualIncome"))
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                    CurrencyText(
                        amount: String(format: "%.0f", annualIncome),
                        amountSize: 15,
                        logoSize: 12,
                        color: .primary,
                        weight: .bold
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .trailing, spacing: 4) {
                    Text(LocalizedStrings.get("detail.appreciation"))
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                    CurrencyText(
                        amount: String(format: "%.0f", appreciation),
                        amountSize: 15,
                        logoSize: 12,
                        color: .primary,
                        weight: .bold
                    )
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }

            HStack(spacing: 16) {
                Button(action: {
                    if investmentAmount > Double(opportunity.minInvestment) {
                        investmentAmount -= 1000
                    }
                }) {
                    Image(systemName: "minus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(width: 44, height: 44)
                        .background(Color(UIColor.systemGray6).cornerRadius(22))
                }

                CurrencyText(
                    amount: String(format: "%.0f", investmentAmount),
                    amountSize: 18,
                    logoSize: 15,
                    color: .primary,
                    weight: .bold
                )
                .frame(maxWidth: .infinity)

                Button(action: {
                    investmentAmount += 1000
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(width: 44, height: 44)
                        .background(Color(UIColor.systemGray6).cornerRadius(22))
                }
            }

            Slider(
                value: $investmentAmount,
                in: Double(opportunity.minInvestment)...100000,
                step: 1000
            )
            .accentColor(.orange)
        }
        .padding(18)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(20)
        .shadow(color: Color.primary.opacity(0.15), radius: 12, x: 0, y: 4)
    }

    // MARK: - Timeline Section
    private var timelineSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(LocalizedStrings.get("detail.timeline"))
                .font(.system(size: 20, weight: .bold))

            ForEach(Array(TimelineItem.mockTimeline.enumerated()), id: \.element.id) { index, item in
                TimelineRow(item: item, isLast: index == TimelineItem.mockTimeline.count - 1)
            }
        }
    }

    // MARK: - Due Diligence Section
    private var dueDiligenceSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(LocalizedStrings.get("detail.dueDiligence"))
                .font(.system(size: 20, weight: .bold))

            HStack(spacing: 16) {
                VStack(spacing: 12) {
                    Image(systemName: "shield.checkerboard")
                        .font(.system(size: 36))
                        .foregroundColor(.primary)

                    Text(LocalizedStrings.get("detail.cmaRegulated"))
                        .font(.system(size: 10, weight: .bold))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)

                VStack(spacing: 12) {
                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.orange)

                    Text(LocalizedStrings.get("detail.shariahCompliant"))
                        .font(.system(size: 10, weight: .bold))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
            }
            .frame(height: 120)

            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.black)
                        .frame(width: 54, height: 54)

                    Text("AC")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(LocalizedStrings.get("company.archCapital"))
                        .font(.system(size: 16, weight: .bold))

                    Text(LocalizedStrings.get("company.archCapitalDesc"))
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(16)
            .background(Color(UIColor.secondarySystemBackground).cornerRadius(16))
        }
    }

    // MARK: - Documents Section
    private var documentsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(DocumentItem.mockDocuments) { document in
                Button(action: {}) {
                    HStack(spacing: 14) {
                        Image(systemName: document.icon)
                            .font(.system(size: 20))
                            .foregroundColor(.secondary)
                            .frame(width: 24)

                        Text(document.title)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.primary)

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 18)
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 1)
                }
            }
        }
    }

    // MARK: - Custom Nav Bar (background appears after scroll)
    private func customNavBar(topInset: CGFloat) -> some View {
        let bgOpacity = min(
            max((heroProgress - CGFloat(0.15)) / CGFloat(0.35), CGFloat(0)),
            CGFloat(1)
        ) // starts after a little scroll // starts after a little scroll

        return ZStack {
            // Background that fades in
            Color(UIColor.systemBackground)
                .opacity(bgOpacity)
                .shadow(color: Color.black.opacity(bgOpacity * 0.08), radius: 10, x: 0, y: 4)

            HStack {
                Button(action: {
                    log("Back tapped")
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: ResponsiveLayout.subtitleSize, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: ResponsiveLayout.iconSize * 0.9, height: ResponsiveLayout.iconSize * 0.9)
                        .background(Color.black.opacity(0.45))
                        .cornerRadius(ResponsiveLayout.iconSize * 0.45)
                }

                Spacer()

                // When collapsed, show the title in the nav bar
                if bgOpacity > 0.55 {
                    Text(opportunity.title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                        .transition(.opacity)
                }

                Spacer()

                Button(action: {
                    log("Share tapped")
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: ResponsiveLayout.subtitleSize, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: ResponsiveLayout.iconSize * 0.9, height: ResponsiveLayout.iconSize * 0.9)
                        .background(Color.black.opacity(0.45))
                        .cornerRadius(ResponsiveLayout.iconSize * 0.45)
                }
            }
            .padding(.leading, ResponsiveLayout.horizontalPadding)
            .padding(.trailing, ResponsiveLayout.horizontalPadding)
        }
        .frame(height: topInset + 54)
        .padding(.top, 0)
        .ignoresSafeArea(edges: .top)
    }

    // MARK: - Bottom Action Bar (compact on scroll)
    private func bottomActionBar(isCompact: Bool) -> some View {
        HStack(spacing: ResponsiveLayout.baseSpacing) {
            if !isCompact {
                VStack(alignment: .leading, spacing: ResponsiveLayout.smallSpacing) {
                    Text(LocalizedStrings.get("detail.minInvestment"))
                        .font(.system(size: ResponsiveLayout.captionSize - 2, weight: .semibold))
                        .foregroundColor(.secondary)
                        .tracking(0.5)
                        .minimumScaleFactor(0.7)
                        .lineLimit(1)

                    CurrencyText(
                        amount: String(format: "%d", opportunity.minInvestment),
                        amountSize: ResponsiveLayout.subtitleSize,
                        logoSize: ResponsiveLayout.bodySize,
                        color: .primary,
                        weight: .bold
                    )
                }

                Spacer(minLength: ResponsiveLayout.smallSpacing)

                Button(action: {
                    log("AddToCart tapped")
                }) {
                    Text(LocalizedStrings.get("detail.addToCart"))
                        .font(.system(size: ResponsiveLayout.bodySize, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, ResponsiveLayout.horizontalPadding)
                        .padding(.vertical, 12) // slightly smaller
                        .background(Color.black)
                        .cornerRadius(ResponsiveLayout.buttonCornerRadius)
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)
                }
            } else {
                // Compact sticky bar: just the button (smaller height)
                Button(action: {
                    log("AddToCart tapped (compact)")
                }) {
                    Text(LocalizedStrings.get("detail.addToCart"))
                        .font(.system(size: ResponsiveLayout.bodySize, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.black)
                        .cornerRadius(ResponsiveLayout.buttonCornerRadius)
                }
            }
        }
        .padding(.horizontal, ResponsiveLayout.horizontalPadding)
        .padding(.vertical, isCompact ? 10 : ResponsiveLayout.baseSpacing)
        .background(
            Color(UIColor.systemBackground)
                .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: -4)
        )
        .animation(.easeInOut(duration: 0.18), value: isCompact)
    }
}

// MARK: - Timeline Row
struct TimelineRow: View {
    let item: TimelineItem
    let isLast: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .stroke(iconColor, lineWidth: 2)
                        .frame(width: 24, height: 24)

                    if item.status == .completed {
                        Circle()
                            .fill(iconColor)
                            .frame(width: 12, height: 12)
                    } else if item.status == .current {
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 12, height: 12)
                    }
                }

                if !isLast {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                }
            }
            .frame(width: 24, height: isLast ? 24 : nil)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(item.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.primary)

                    if item.status == .current {
                        Text(LocalizedStrings.get("detail.current"))
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.orange)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.orange.opacity(0.1).cornerRadius(4))
                    }
                }

                Text(item.date)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)

                Text(item.description)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .padding(.top, 2)
            }
            .padding(.bottom, isLast ? 0 : 20)
        }
    }

    private var iconColor: Color {
        switch item.status {
        case .completed: return .green
        case .current: return .orange
        case .upcoming: return .gray
        }
    }
}

// MARK: - UIScrollView Offset Detector (Verbose Debug)
private struct ScrollViewOffsetDetector: UIViewRepresentable {
    let tag: String
    let debug: Bool
    let onOffsetChange: (CGFloat) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(tag: tag, debug: debug, onOffsetChange: onOffsetChange)
    }

    func makeUIView(context: Context) -> UIView {
        if debug {
            print("🧪 [\(tag)] makeUIView")
        }
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false

        DispatchQueue.main.async {
            if debug {
                print("🧪 [\(tag)] makeUIView async attachIfNeeded")
            }
            context.coordinator.attachIfNeeded(from: view)
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if debug {
            print("🧪 [\(tag)] updateUIView")
        }
        DispatchQueue.main.async {
            if debug {
                print("🧪 [\(tag)] updateUIView async attachIfNeeded")
            }
            context.coordinator.attachIfNeeded(from: uiView)
        }
    }

    final class Coordinator: NSObject {
        private let tag: String
        private let debug: Bool
        private let onOffsetChange: (CGFloat) -> Void

        private var observation: NSKeyValueObservation?
        private weak var scrollView: UIScrollView?

        private var retryCount: Int = 0
        private let maxRetries: Int = 30

        private var lastPrintedY: CGFloat = -99999

        init(tag: String, debug: Bool, onOffsetChange: @escaping (CGFloat) -> Void) {
            self.tag = tag
            self.debug = debug
            self.onOffsetChange = onOffsetChange
        }

        func attachIfNeeded(from view: UIView) {
            if debug {
                print("🧪 [\(tag)] attachIfNeeded called. retry=\(retryCount)")
            }

            if scrollView != nil {
                if debug {
                    print("🧪 [\(tag)] already attached to UIScrollView")
                }
                return
            }

            guard let sv = view.findEnclosingScrollView(debug: debug, tag: tag) else {
                if debug {
                    print("⚠️ [\(tag)] No UIScrollView found yet from detector view")
                }
                retryCount += 1
                guard retryCount <= maxRetries else {
                    if debug {
                        print("❌ [\(tag)] maxRetries reached. Giving up attaching.")
                    }
                    return
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                    guard let self else { return }
                    self.attachIfNeeded(from: view)
                }
                return
            }

            scrollView = sv

            if debug {
                print("✅ [\(tag)] Found UIScrollView: \(sv)")
                print("✅ [\(tag)] Initial contentOffset.y: \(sv.contentOffset.y)")
            }

            onOffsetChange(sv.contentOffset.y)

            observation = sv.observe(\.contentOffset, options: [.new]) { [weak self] scrollView, _ in
                guard let self else { return }
                let y = scrollView.contentOffset.y
                self.onOffsetChange(y)

                if self.debug {
                    if abs(y - self.lastPrintedY) >= 8 {
                        self.lastPrintedY = y
                        print("📍 [\(self.tag)] contentOffset changed -> y=\(y)")
                    }
                }
            }

            if debug {
                print("✅ [\(tag)] KVO observation attached")
            }
        }
    }
}

private extension UIView {
    func findEnclosingScrollView(debug: Bool, tag: String) -> UIScrollView? {
        var v: UIView? = self
        var depth = 0

        while let current = v {
            if debug {
                let typeName = String(describing: type(of: current))
                print("🔎 [\(tag)] superview[\(depth)]: \(typeName)")
            }

            if let sv = current as? UIScrollView {
                if debug {
                    print("🎯 [\(tag)] Matched UIScrollView at depth \(depth)")
                }
                return sv
            }

            v = current.superview
            depth += 1

            if depth > 80 {
                if debug {
                    print("❌ [\(tag)] superview chain too deep, aborting")
                }
                return nil
            }
        }

        if debug {
            print("❌ [\(tag)] reached top of hierarchy without finding UIScrollView")
        }
        return nil
    }
}

// MARK: - Preview
struct OpportunityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        OpportunityDetailView(opportunity: InvestmentOpportunity.mockData[0], hideTabBar: .constant(true))
    }
}
