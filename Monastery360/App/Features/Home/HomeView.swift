import SwiftUI
import Observation

struct HomeView: View {
    @Environment(Router.self) var router
    @Environment(\.diContainer) var di
    
    // Derived from DI or Environment
    var authService: AuthService { di.authService }
    
    @State private var repo: MonasteryRepository?
    
    @State private var featured: Monastery?
    @State private var nearby: [Monastery] = []
    @State private var popular: [Monastery] = []
    
    var body: some View {
        NavigationStack(path: Bindable(router).homePath) {
            ScrollView {
                // ... (Content)
                VStack(spacing: Space.xl) {
                    
                    // 1. Header is custom, handled by parent or sticky if needed.
                    // For MVP simplicity, simple header:
                    HStack {
                        VStack(alignment: .leading) {
                            // "Pilgrim" is more immersive than "Guest"
                            Text(authService.user?.displayName ?? "Pilgrim")
                                .style(Typography.h2)
                            Text(Date().formatted(date: .abbreviated, time: .omitted))
                                .style(Typography.caption)
                                .foregroundStyle(Color.Text.secondary)
                        }
                        Spacer()
                        Button(action: {}) { // Placeholder for notifications
                            Image(systemName: "bell.fill")
                                .foregroundColor(Color.Text.primary)
                        }
                        Button(action: { router.navigate(to: .profile) }) {
                             Image(systemName: "person.circle.fill")
                                .font(.title)
                                .foregroundColor(Color.Text.primary)
                        }
                    }
                    .padding(.horizontal, Space.lg)
                    .padding(.top, Space.md)
                    
                    // 2. Featured
                    if let featured = featured {
                        FeaturedHeroCard(monastery: featured)
                            .padding(.horizontal, Space.lg)
                            .onTapGesture {
                                // Navigate to Detail
                                router.navigate(to: .monasteryDetail(id: featured.id ?? ""))
                            }
                    }
                    
                    // 3. Quick Actions
                    HStack(spacing: Space.lg) {
                        QuickActionButton(icon: "camera.aperture", label: "360°") {
                            // Navigate to a 360 experience logic or Discovery
                            router.selectedTab = .discovery // Explore
                        }
                        QuickActionButton(icon: "map", label: "Map") {
                            router.selectedTab = .map // Map
                        }
                        QuickActionButton(icon: "magnifyingglass", label: "Search") {
                            router.selectedTab = .discovery // Explore (Discovery)
                        }
                    }
                    .padding(.horizontal, Space.lg)
                    
                    // 4. Nearby
                    SectionHeader(title: "Nearby Sanctuaries") {
                        router.selectedTab = .map // Map shows nearby
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Space.md) {
                            ForEach(nearby) { item in
                                MonasteryCompactCard(monastery: item)
                                    .onTapGesture { router.navigate(to: .monasteryDetail(id: item.id ?? "")) }
                            }
                        }
                        .padding(.horizontal, Space.lg)
                    }
                    
                    // 5. Popular
                    SectionHeader(title: "Most Popular") {
                        router.selectedTab = .discovery // Explore
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: Space.md) {
                            ForEach(popular) { item in
                                MonasteryCompactCard(monastery: item)
                                    .onTapGesture { router.navigate(to: .monasteryDetail(id: item.id ?? "")) }
                            }
                        }
                        .padding(.horizontal, Space.lg)
                    }
                    
                    // 6. Spiritual Quote
                    QuoteCard()
                        .padding(.horizontal, Space.lg)
                        .padding(.bottom, Space.xxl)
                }
            }
            .background(Color.Surface.base.ignoresSafeArea())
            .onAppear {
                if repo == nil {
                    self.repo = MonasteryRepository(firestoreService: di.firestoreService, tenantService: di.tenantService)
                }
                loadData()
            }
            .withRouteHandler()
        }
    }
    
    func loadData() {
        guard let repo = repo else { return }
        Task {
            self.featured = try? await repo.fetchFeatured()
            self.nearby = (try? await repo.fetchNearby(lat: 0, lng: 0)) ?? []
            self.popular = (try? await repo.fetchPopular()) ?? []
        }
    }
}

// Helpers
struct SectionHeader: View {
    let title: String
    var onShowAll: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Text(title).style(Typography.h3)
            Spacer()
            if let onShowAll {
                Button(action: onShowAll) {
                    Text("Show All").font(.caption).foregroundStyle(Color.Brand.primary)
                }
            }
        }
        .padding(.horizontal, Space.lg)
    }
}

struct QuickActionButton: View {
    let icon: String
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Circle()
                .fill(Color.Surface.interaction)
                .frame(width: 50, height: 50)
                .overlay(Image(systemName: icon).foregroundStyle(Color.Brand.primary))
                Text(label).style(Typography.caption)
            }
        }
        .buttonStyle(.plain)
    }
}

struct QuoteCard: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: Space.sm) {
                Text("Daily Wisdom")
                    .font(.caption).bold().foregroundStyle(Color.Brand.secondary)
                Text("The mind is everything. What you think you become.")
                    .font(.body).italic()
                    .foregroundStyle(Color.Text.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color.Surface.secondary)
        .cornerRadius(Radius.md)
    }
}
