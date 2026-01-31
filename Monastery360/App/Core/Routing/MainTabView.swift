import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabDestination = .home
    
    enum TabDestination {
        case home, discovery, map, saved, profile
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(TabDestination.home)
            
            DiscoveryView()
                .tabItem {
                    Label("Explore", systemImage: "compass")
                }
                .tag(TabDestination.discovery)
            
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(TabDestination.map)
            
            SavedView()
                .tabItem {
                    Label("Saved", systemImage: "bookmark")
                }
                .tag(TabDestination.saved)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
                .tag(TabDestination.profile)
        }
        .tint(Color.Brand.primary)
    }
}
