//
//  OpportunitiesView.swift
//  SaudiOnboardingDemo
//
//  DEBUG BUILD VERSION:
//  - Adds extensive print logs to diagnose why scroll offset isn't detected.
//  - Collapsing header + search on scroll, pinned filters remain visible.
//

import SwiftUI
import UIKit

// MARK: - Opportunities View
struct OpportunitiesView: View {

    // MARK: - Properties
    @StateObject private var viewModel = OpportunitiesViewModel()
    @State private var selectedTab: Int = 0

    // Scroll tracking
    @State private var scrollOffsetY: CGFloat = 0

    // MARK: - Debug
    private let debugLogsEnabled: Bool = true
    private func log(_ message: String) {
        guard debugLogsEnabled else { return }
        print("🧩 [OpportunitiesView] \(message)")
    }

    // MARK: - Tuning
    private let headerCollapseDistance: CGFloat = 120
    private let searchCollapseDistance: CGFloat = 80

    private var scrollY: CGFloat { max(0, scrollOffsetY) }

    private var headerProgress: CGFloat {
        min(scrollY / headerCollapseDistance, 1)
    }

    private var searchProgress: CGFloat {
        min(scrollY / searchCollapseDistance, 1)
    }

    private var headerHidden: Bool { headerProgress >= 1 }
    private var searchHidden: Bool { searchProgress >= 1 }

    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {

                        // Header content that collapses & disappears
                        headerSection
                            .scaleEffect(1 - (0.08 * headerProgress), anchor: .topLeading)
                            .opacity(1 - headerProgress)
                            .frame(height: headerHidden ? 0 : nil)
                            .clipped()
                            .onAppear { log("headerSection appeared") }

                        // Search bar content that collapses & disappears faster
                        searchBarSection
                            .scaleEffect(1 - (0.06 * searchProgress), anchor: .top)
                            .opacity(1 - searchProgress)
                            .frame(height: searchHidden ? 0 : nil)
                            .clipped()
                            .allowsHitTesting(!searchHidden)
                            .onAppear { log("searchBarSection appeared") }

                        // Section with pinned filters
                        Section {
                            ForEach(viewModel.filteredOpportunities) { opportunity in
                                NavigationLink(
                                    destination: OpportunityDetailView(
                                        opportunity: opportunity,
                                        hideTabBar: .constant(true)
                                    )
                                ) {
                                    OpportunityCard(opportunity: opportunity)
                                }
                                .buttonStyle(.plain)
                                .padding(.horizontal, ResponsiveLayout.horizontalPadding)
                                .padding(.bottom, ResponsiveLayout.sectionSpacing)
                                .onAppear {
                                    if debugLogsEnabled {
                                        log("OpportunityCard appeared: id=\(opportunity.id)")
                                    }
                                }
                            }
                        } header: {
                            filterSectionPinned
                                .onAppear { log("filterSectionPinned appeared") }
                        }
                    }
                    .padding(.bottom, ResponsiveLayout.baseSpacing)
                }
                .onAppear {
                    log("ScrollView appeared")
                }
                .onChange(of: scrollOffsetY) { newValue in
                    // WARNING: This prints a lot while scrolling. Turn off debugLogsEnabled after testing.
                    log("scrollOffsetY changed -> \(newValue)")
                }
                .overlay(alignment: .topLeading) {
                    // Put the detector in the view hierarchy in a guaranteed way.
                    ScrollViewOffsetDetector(tag: "OpportunitiesView", debug: debugLogsEnabled) { y in
                        scrollOffsetY = y
                        if debugLogsEnabled {
                            print("🧭 [OffsetDetector] callback y=\(y)")
                        }
                    }
                    .frame(width: 1, height: 1)
                    .allowsHitTesting(false)
                }
            }
            .navigationBarHidden(true)
            .safeAreaInset(edge: .bottom) {
                BottomNavigationBar(selectedTab: $selectedTab)
            }
        }
        .navigationViewStyle(.stack)
        .onAppear {
            log("OpportunitiesView appeared. filteredCount=\(viewModel.filteredOpportunities.count)")
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: ResponsiveLayout.smallSpacing) {
                Text(LocalizedStrings.get("opportunities.title"))
                    .font(.system(size: ResponsiveLayout.largeTitleSize, weight: .bold))
                    .foregroundColor(.primary)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)

                Text(LocalizedStrings.get("opportunities.subtitle"))
                    .font(.system(size: ResponsiveLayout.bodySize))
                    .foregroundColor(.secondary)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
            }

            Spacer()

            Button(action: {
                log("Top-right filter icon tapped")
                // Filter action
            }) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: ResponsiveLayout.subtitleSize))
                    .foregroundColor(.primary)
                    .frame(width: ResponsiveLayout.iconSize, height: ResponsiveLayout.iconSize)
            }
        }
        .responsivePadding()
        .padding(.top, ResponsiveLayout.baseSpacing)
        .padding(.bottom, ResponsiveLayout.smallSpacing)
        .background(Color(UIColor.systemBackground))
    }

    // MARK: - Search Bar Section
    private var searchBarSection: some View {
        HStack(spacing: ResponsiveLayout.baseSpacing) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .font(.system(size: ResponsiveLayout.subtitleSize))

            TextField(LocalizedStrings.get("opportunities.search"), text: $viewModel.searchText)
                .font(.system(size: ResponsiveLayout.bodySize))
                .onChange(of: viewModel.searchText) { newValue in
                    log("searchText changed -> \(newValue)")
                }
        }
        .padding(.horizontal, ResponsiveLayout.baseSpacing)
        .padding(.vertical, ResponsiveLayout.baseSpacing)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(ResponsiveLayout.buttonCornerRadius)
        .responsivePadding()
        .padding(.bottom, ResponsiveLayout.baseSpacing)
        .background(Color(UIColor.systemBackground))
    }

    // MARK: - Filter Section (Pinned)
    private var filterSectionPinned: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: ResponsiveLayout.baseSpacing) {
                ForEach(PropertyType.allCases) { type in
                    FilterButton(
                        title: type.displayName,
                        isSelected: viewModel.selectedFilter == type
                    ) {
                        log("Filter selected -> \(type.displayName)")
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.selectFilter(type)
                        }
                    }
                }
            }
            .responsivePadding()
        }
        .padding(.vertical, 10)
        .background(
            Color(UIColor.systemBackground)
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
        .overlay(
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 0.5),
            alignment: .bottom
        )
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

        // Throttle logs a bit to avoid insane spam
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

            // Initial value
            onOffsetChange(sv.contentOffset.y)

            // Observe changes
            observation = sv.observe(\.contentOffset, options: [.new]) { [weak self] scrollView, change in
                guard let self else { return }
                let y = scrollView.contentOffset.y
                self.onOffsetChange(y)

                if self.debug {
                    // print every ~5pt change
                    if abs(y - self.lastPrintedY) >= 5 {
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

// MARK: - Filter Button Component
struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: ResponsiveLayout.bodySize, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, ResponsiveLayout.baseSpacing)
                .padding(.vertical, ResponsiveLayout.smallSpacing)
                .background(isSelected ? Color.black : Color(UIColor.systemGray6))
                .cornerRadius(ResponsiveLayout.largeCornerRadius)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
        }
    }
}

// MARK: - Preview
struct OpportunitiesView_Previews: PreviewProvider {
    static var previews: some View {
        OpportunitiesView()
    }
}
