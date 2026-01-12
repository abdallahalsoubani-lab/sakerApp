//
//  BottomNavigationBar.swift
//  SaudiOnboardingDemo
//
//  Created on 2026-01-11
//

import SwiftUI

// MARK: - Bottom Navigation Bar
struct BottomNavigationBar: View {
    
    // MARK: - Properties
    @Binding var selectedTab: Int
    var onTabSelected: ((Int) -> Void)? = nil
    
    // MARK: - Tab Items
    private var tabs: [(icon: String, title: String)] {
        return [
            ("house.fill", LocalizedStrings.get("nav.invest")),
            ("chart.bar.fill", LocalizedStrings.get("nav.myInvestments")),
            ("wallet.pass.fill", LocalizedStrings.get("nav.wallet")),
            ("person.fill", LocalizedStrings.get("nav.profile"))
        ]
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedTab = index
                            onTabSelected?(index)
                        }
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: tabs[index].icon)
                                .font(.system(size: 24))
                                .foregroundColor(selectedTab == index ? .primary : .gray)
                            
                            Text(tabs[index].title)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(selectedTab == index ? .primary : .gray)
                            
                            // Active Indicator
                            if selectedTab == index {
                                Circle()
                                    .fill(Color.orange)
                                    .frame(width: 6, height: 6)
                                    .transition(.scale)
                            } else {
                                Circle()
                                    .fill(Color.clear)
                                    .frame(width: 6, height: 6)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 8)
            
            // Safe Area Extension
            Color(UIColor.systemBackground)
                .frame(height: 0)
                .ignoresSafeArea(edges: .bottom)
        }
        .background(
            Color(UIColor.systemBackground)
                .ignoresSafeArea(edges: .bottom)
                .shadow(color: Color.primary.opacity(0.15), radius: 10, x: 0, y: -5)
        )
    }
}

// MARK: - Preview
struct BottomNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavigationBar(selectedTab: .constant(0))
            .previewLayout(.sizeThatFits)
    }
}
