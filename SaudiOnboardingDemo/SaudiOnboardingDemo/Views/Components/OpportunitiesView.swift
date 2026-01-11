import SwiftUI

struct OpportunitiesView: View {
    private let gutter: CGFloat = 20

    @State private var selectedTab: Int = 0
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    Text("Upcoming Opportunities")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    ForEach(0..<10) { index in
                        OpportunityCardView(index: index)
                    }
                }
                .safeAreaPadding(.horizontal, gutter)
                .padding(.top, 20)
            }
        }
        .safeAreaInset(edge: .bottom) {
            BottomNavigationBar(selectedTab: $selectedTab)
        }
    }
}

struct OpportunityCardView: View {
    let index: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Opportunity \(index + 1)")
                .font(.headline)
            Text("This is a description for opportunity number \(index + 1).")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct BottomNavigationBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack {
            Button(action: { selectedTab = 0 }) {
                VStack {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            }
            Spacer()
            Button(action: { selectedTab = 1 }) {
                VStack {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            }
            Spacer()
            Button(action: { selectedTab = 2 }) {
                VStack {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
            }
        }
        .padding()
        .background(Color.white)
        .shadow(radius: 5)
    }
}
