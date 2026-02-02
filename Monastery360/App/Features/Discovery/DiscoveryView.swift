import SwiftUI
import Observation

struct DiscoveryView: View {
    @Environment(\.diContainer) var di
    @Environment(Router.self) var router
    
    @State private var repo: MonasteryRepository?
    
    @State private var searchText = ""
    @State private var searchResults: [Monastery] = []
    @State private var monasteries: [Monastery] = []
    @State private var showVoiceSearchAlert = false
    
    @State private var activeFilter: String = "All"
    
    // Filters
    let filters = ["All", "Nyingma", "Kagyu", "Ancient", "Accessible"]
    
    // Repository
    
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
                    Button(action: { showVoiceSearchAlert = true }) {
                        Image(systemName: "mic.fill")
                            .foregroundStyle(Color.Brand.tertiary)
                    }
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
                .onChange(of: searchText) { _, newValue in
                    if repo == nil {
                        repo = MonasteryRepository(firestoreService: di.firestoreService, tenantService: di.tenantService)
                    }
                    
                    guard !newValue.isEmpty, let repo = repo else {
                        // Reset to all if cleared
                        loadData()
                        return
                    }
                    
                    Task {
                        do {
                            let results = try await repo.search(query: newValue)
                             await MainActor.run {
                                 // Update main list to show results
                                 self.monasteries = results
                             }
                        } catch {
                            print("Search error: \(error)")
                        }
                    }
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
            .alert("Voice Search", isPresented: $showVoiceSearchAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Voice search is coming in the next update! 🙏")
            }
            .onAppear {
                loadData()
            }
            .withRouteHandler()
        }
    }
    
    func loadData() {
        Task {
            if let repo = repo {
                // Determine what to load based on active filter
                if activeFilter == "All" {
                     monasteries = (try? await repo.fetchAll()) ?? []
                } else {
                     // Fetch all and filter locally (repo.fetchAll is efficient for this dataset size)
                     let all = (try? await repo.fetchAll()) ?? []
                     monasteries = all.filter { $0.tags.contains(activeFilter.lowercased()) || ($0.sectTradition == activeFilter) }
                }
            }
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
            Group {
                if let url = URL(string: monastery.thumbnailUrl), !monastery.thumbnailUrl.isEmpty {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            Rectangle().fill(Color.Surface.interaction)
                        case .success(let image):
                            image.resizable().aspectRatio(contentMode: .fill)
                        case .failure:
                             Rectangle().fill(Color.gray.opacity(0.3)).overlay(Image(systemName: "photo"))
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else if let first = monastery.galleryUrls?.first, let url = URL(string: first) {
                     AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image.resizable().aspectRatio(contentMode: .fill)
                        } else {
                            Rectangle().fill(Color.gray.opacity(0.3)).overlay(Image(systemName: "photo"))
                        }
                     }
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(Image(systemName: "photo"))
                }
            }
            .frame(width: 80, height: 80)
            .cornerRadius(Radius.md)
            .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(monastery.name.en).style(Typography.bodyLg)
                Text(monastery.sectTradition ?? "Unknown").style(Typography.caption).foregroundStyle(Color.Brand.secondary)
                Text(monastery.location.lat != 0 ? "Sikkim, India" : "").style(Typography.caption).foregroundStyle(Color.Text.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(Color.Text.tertiary)
        }
        .padding(.vertical, Space.sm)
        .contentShape(Rectangle())
    }
}
