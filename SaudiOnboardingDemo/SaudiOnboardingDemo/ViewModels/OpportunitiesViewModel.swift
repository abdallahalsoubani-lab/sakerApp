//
//  OpportunitiesViewModel.swift
//  SaudiOnboardingDemo
//
//  Created on 2026-01-11
//

import Foundation
import Combine

// MARK: - Opportunities ViewModel
class OpportunitiesViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var opportunities: [InvestmentOpportunity] = []
    @Published var filteredOpportunities: [InvestmentOpportunity] = []
    @Published var selectedFilter: PropertyType = .all
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init() {
        loadOpportunities()
        setupSearchAndFilter()
    }
    
    // MARK: - Public Methods
    func loadOpportunities() {
        isLoading = true
        
        // Simulate API call with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.opportunities = InvestmentOpportunity.mockData
            self?.isLoading = false
        }
    }
    
    func selectFilter(_ filter: PropertyType) {
        selectedFilter = filter
    }
    
    // MARK: - Private Methods
    private func setupSearchAndFilter() {
        // Combine search and filter publishers
        Publishers.CombineLatest3(
            $opportunities,
            $selectedFilter,
            $searchText
        )
        .map { [weak self] opportunities, filter, searchText in
            self?.filterOpportunities(
                opportunities: opportunities,
                filter: filter,
                searchText: searchText
            ) ?? []
        }
        .assign(to: &$filteredOpportunities)
    }
    
    private func filterOpportunities(
        opportunities: [InvestmentOpportunity],
        filter: PropertyType,
        searchText: String
    ) -> [InvestmentOpportunity] {
        var filtered = opportunities
        
        // Apply type filter
        if filter != .all {
            filtered = filtered.filter { $0.type == filter }
        }
        
        // Apply search filter
        if !searchText.isEmpty {
            filtered = filtered.filter { opportunity in
                opportunity.title.localizedCaseInsensitiveContains(searchText) ||
                opportunity.location.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered
    }
}
