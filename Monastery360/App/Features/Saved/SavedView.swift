import SwiftUI

struct SavedView: View {
    @Environment(Router.self) var router
    @State private var selectedTab = 0
    @State private var favorites: [Monastery] = []
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Your Collection").style(Typography.h3).padding()
            
            Picker("Tabs", selection: $selectedTab) {
                Text("Favorites").tag(0)
                Text("Downloads").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, Space.lg)
            .padding(.bottom, Space.md)
            
            if favorites.isEmpty {
                VStack(spacing: Space.md) {
                    Spacer()
                    Image(systemName: "bookmark.slash")
                        .font(.system(size: 50))
                        .foregroundStyle(Color.Text.tertiary)
                    Text("No saved sanctuaries yet.")
                        .style(Typography.bodyMd)
                        .foregroundStyle(Color.Text.secondary)
                    Spacer()
                }
            } else {
                List {
                    ForEach(favorites) { item in
                        DiscoveryRow(monastery: item) // Reusing row component
                            .onTapGesture {
                                router.navigate(to: .monasteryDetail(id: item.id ?? ""))
                            }
                    }
                }
                .listStyle(.plain)
            }
        }
        .onAppear {
            // Mock load
            favorites = [.mockRumtek]
        }
    }
}
