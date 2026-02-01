import SwiftUI
import Observation

struct DiscoveryView: View {
    @Environment(Router.self) var router
    @State private var searchText = ""
    @State private var activeFilter: String = "All"
    @State private var monasteries: [Monastery] = []
    
    // Filters
    let filters = ["All", "Nyingma", "Kagyu", "Ancient", "Accessible"]
    
    // Repository
    @State private var repo = MonasteryRepository()
    
    var body: some View {
        NavigationStack(path: Bindable(router).discoveryPath) {
            VStack(spacing: 0) {
                // 1. Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(Color.Text.secondary)
                    TextField("Search temples, history...", text: $searchText)
                        .foregroundStyle(Color.Text.primary)
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(Color.Text.secondary)
                        }
                    }
                    Image(systemName: "mic.fill")
                        .foregroundStyle(Color.Brand.tertiary)
                }
                .padding()
                .background(Color.Surface.interaction)
                .cornerRadius(Radius.pill)
                .padding(Space.lg)
                
                // 2. Filter Ribbon
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Space.sm) {
                        ForEach(filters, id: \.self) { filter in
                            FilterChip(label: filter, isSelected: activeFilter == filter) {
                                activeFilter = filter
                                filterData()
                            }
                        }
                    }
                    .padding(.horizontal, Space.lg)
                }
                .padding(.bottom, Space.md)
                
                // 3. List
                List {
                    ForEach(monasteries) { item in
                        DiscoveryRow(monastery: item)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .onTapGesture {
                                router.navigate(to: .monasteryDetail(id: item.id ?? ""))
                            }
                    }
                }
                .listStyle(.plain)
            }
            .background(Color.Surface.base)
            .onAppear {
                loadData()
            }
            .withRouteHandler()
        }
    }
    
    func loadData() {
        Task {
            monasteries = (try? await repo.fetchPopular()) ?? []
        }
    }
    
    func filterData() {
        // Local filtering of fetched dataset
        if activeFilter == "All" {
            loadData()
        } else {
            monasteries = monasteries.filter { $0.tags.contains(activeFilter.lowercased()) || ($0.sectTradition == activeFilter) }
        }
    }
}

struct FilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(Typography.caption)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.Brand.primary : Color.Surface.interaction)
                .foregroundStyle(isSelected ? Color.Text.inverse : Color.Text.primary)
                .cornerRadius(Radius.pill)
        }
    }
}

struct DiscoveryRow: View {
    let monastery: Monastery
    
    var body: some View {
        HStack(spacing: Space.md) {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 80, height: 80)
                .cornerRadius(Radius.md)
                .overlay(Image(systemName: "photo"))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(monastery.name.en).style(Typography.bodyLg)
                Text(monastery.sectTradition ?? "Unknown").style(Typography.caption).foregroundStyle(Color.Brand.secondary)
                Text(monastery.location.lat != 0 ? "Sikkim, India" : "").style(Typography.caption).foregroundStyle(Color.Text.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(Color.Text.tertiary)
        }
        .padding(.vertical, Space.sm)
    }
}
