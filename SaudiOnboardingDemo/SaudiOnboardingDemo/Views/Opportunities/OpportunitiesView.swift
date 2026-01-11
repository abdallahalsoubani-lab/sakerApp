//
//  OpportunitiesView.swift
//  SaudiOnboardingDemo
//
//  Created on 2026-01-11
//

import SwiftUI

// MARK: - Opportunities View
struct OpportunitiesView: View {
    
    // MARK: - Properties
    @StateObject private var viewModel = OpportunitiesViewModel()
    @State private var selectedTab: Int = 0
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                headerSection
                
                // Search Bar
                searchBarSection
                
                // Filter Buttons
                filterSection
                
                // Opportunities List
                opportunitiesListSection
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarHidden(true)
            .safeAreaInset(edge: .bottom) {
                BottomNavigationBar(selectedTab: $selectedTab)
            }
        }
        .navigationViewStyle(.stack)
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: ResponsiveLayout.smallSpacing) {
                Text("Opportunities")
                    .font(.system(size: ResponsiveLayout.largeTitleSize, weight: .bold))
                    .foregroundColor(.primary)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
                
                Text("Explore vetted real estate assets")
                    .font(.system(size: ResponsiveLayout.bodySize))
                    .foregroundColor(.secondary)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Button(action: {
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
            
            TextField("Search location or asset...", text: $viewModel.searchText)
                .font(.system(size: ResponsiveLayout.bodySize))
        }
        .padding(.horizontal, ResponsiveLayout.baseSpacing)
        .padding(.vertical, ResponsiveLayout.baseSpacing)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(ResponsiveLayout.buttonCornerRadius)
        .responsivePadding()
        .padding(.bottom, ResponsiveLayout.baseSpacing)
        .background(Color(UIColor.systemBackground))
    }
    
    // MARK: - Filter Section
    private var filterSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: ResponsiveLayout.baseSpacing) {
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
            .responsivePadding()
        }
        .padding(.vertical, ResponsiveLayout.baseSpacing)
        .background(Color(UIColor.systemBackground))
    }
    
    // MARK: - Opportunities List Section
    private var opportunitiesListSection: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: ResponsiveLayout.sectionSpacing) {
                ForEach(viewModel.filteredOpportunities) { opportunity in
                    NavigationLink(destination: OpportunityDetailView(opportunity: opportunity, hideTabBar: .constant(true))) {
                        OpportunityCard(opportunity: opportunity)
                    }
                    .buttonStyle(.plain)
                }
            }
            .responsivePadding()
            .padding(.vertical, ResponsiveLayout.baseSpacing)
        }
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
