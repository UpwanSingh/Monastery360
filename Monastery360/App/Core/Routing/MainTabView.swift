import SwiftUI
import Observation

struct MainTabView: View {
    @Environment(Router.self) var router
    
    var body: some View {
        TabView(selection: Bindable(router).selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(AppTab.home)
            
            DiscoveryView()
                .tabItem {
                    Label("Explore", systemImage: "safari")
                }
                .tag(AppTab.discovery)
            
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(AppTab.map)
            
            SavedView()
                .tabItem {
                    Label("Saved", systemImage: "bookmark")
                }
                .tag(AppTab.saved)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
                .tag(AppTab.profile)
        }
        .tint(Color.Brand.primary)
    }
}
