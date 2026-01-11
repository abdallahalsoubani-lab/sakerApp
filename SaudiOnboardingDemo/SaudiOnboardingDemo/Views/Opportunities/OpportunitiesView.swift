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
    
    // MARK: - Constants
    private let gutter: CGFloat = 20
    
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
            VStack(alignment: .leading, spacing: 4) {
                Text("Opportunities")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Explore vetted real estate assets")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {
                // Filter action
            }) {
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
    
    // MARK: - Search Bar Section
    private var searchBarSection: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .font(.system(size: 18))
            
            TextField("Search location or asset...", text: $viewModel.searchText)
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
    
    // MARK: - Filter Section
    private var filterSection: some View {
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
        .padding(.vertical, 16)
        .background(Color(UIColor.systemBackground))
    }
    
    // MARK: - Opportunities List Section
    private var opportunitiesListSection: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 20) {
                ForEach(viewModel.filteredOpportunities) { opportunity in
                    NavigationLink(destination: OpportunityDetailView(opportunity: opportunity, hideTabBar: .constant(true))) {
                        OpportunityCard(opportunity: opportunity)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, gutter)
            .padding(.vertical, 20)
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
                .font(.system(size: 15, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(isSelected ? Color.black : Color(UIColor.systemGray6))
                .cornerRadius(20)
        }
    }
}

// MARK: - Preview
struct OpportunitiesView_Previews: PreviewProvider {
    static var previews: some View {
        OpportunitiesView()
    }
}
