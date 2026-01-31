import SwiftUI

struct RootView: View {
    @State var appState = AppState()
    @State var di = DIContainer() // Initialize DI
    
    var body: some View {
        Group {
            switch appState.currentRoute {
            case .splash:
                SplashView()
            case .onboarding:
                OnboardingView()
            case .authSelection:
                AuthSelectionView()
            case .mainTab:
                MainTabView() // To be implemented in next step
            }
        }
        .environment(appState)
        .environment(di)
        // Inject Services specifically if needed, but DIContainer covers it
        .environment(di.authService)
        .environment(di.tenantService)
    }
}

// Temporary placeholder for MainTab to allow compilation
struct MainTabView: View {
    var body: some View {
        Text("Main Tab - Home")
    }
}
