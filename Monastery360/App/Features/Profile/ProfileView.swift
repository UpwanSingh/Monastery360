import SwiftUI

struct ProfileView: View {
    @Environment(DIContainer.self) var di
    @Environment(AppState.self) var appState
    
    var body: some View {
        VStack(spacing: Space.xl) {
            
            // Avatar
            Circle()
                .fill(Color.Surface.interaction)
                .frame(width: 100, height: 100)
                .overlay(Text("US").style(Typography.h2))
            
            Text("Tashi Delek, User")
                .style(Typography.h2)
            
            List {
                Section {
                    NavigationLink("Settings") { SettingsView() }
                    NavigationLink("Offline Storage") { OfflineStorageView() }
                    NavigationLink("About & Info") { AboutView() }
                }
                
                Section {
                    Button("Sign Out") {
                        try? di.authService.signOut()
                        appState.isAuthenticated = false
                        appState.currentRoute = .authSelection
                    }
                    .foregroundStyle(Color.state.error)
                }
            }
        }
        .background(Color.Surface.secondary)
    }
}
