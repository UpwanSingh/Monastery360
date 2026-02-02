import SwiftUI

struct RootView: View {
    @Environment(AppState.self) var appState
    @Environment(\.diContainer) var di
    
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
                MainTabView()
            }
        }
        // No need to re-inject environment here, they cascade from App
    }
}


