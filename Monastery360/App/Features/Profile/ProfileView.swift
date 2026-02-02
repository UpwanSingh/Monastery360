import SwiftUI

struct ProfileView: View {
    @Environment(\.diContainer) var di
    @Environment(AppState.self) var appState
    @Environment(Router.self) var router
    
    @State private var viewModel: ProfileViewModel?
    
    var body: some View {
        NavigationStack(path: Bindable(router).profilePath) {
            VStack(spacing: Space.xl) {
                
                if let vm = viewModel {
                    // Avatar
                    Circle()
                        .fill(Color.Surface.interaction)
                        .frame(width: 100, height: 100)
                        .overlay(Text(vm.userInitials).style(Typography.h2))
                    
                    Text("Tashi Delek, \(vm.userName == "Guest" ? "Pilgrim" : vm.userName)")
                        .style(Typography.h2)
                    
                    List {
                        Section {
                            NavigationLink("Settings") { SettingsView() }
                            NavigationLink("Offline Storage") { OfflineStorageView() }
                            NavigationLink("About & Info") { AboutView() }
                        }
                        
                        Section {
                            Button("Sign Out") {
                                do {
                                    try vm.signOut()
                                    appState.isAuthenticated = false
                                    appState.currentRoute = .authSelection
                                } catch {
                                    print("Sign out error: \(error)")
                                }
                            }
                            .foregroundStyle(Color.State.error)
                        }
                    }
                }
            }
            .background(Color.Surface.secondary)
            .withRouteHandler()
        }
        .onAppear {
            if viewModel == nil {
                self.viewModel = ProfileViewModel(authService: di.authService)
            }
        }
    }
}
