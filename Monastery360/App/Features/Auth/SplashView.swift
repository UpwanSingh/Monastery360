import SwiftUI

struct SplashView: View {
    @Environment(AppState.self) private var appState
    @Environment(TenantService.self) private var tenantService
    
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            Color.Surface.base
                .ignoresSafeArea()
            
            VStack(spacing: Space.lg) {
                Image(systemName: "building.columns.fill") // Placeholder for Lottie/Logo
                    .font(.system(size: 80))
                    .foregroundStyle(Color.Brand.primary)
                
                Text("Monastery 360")
                    .style(Typography.display)
                    .foregroundStyle(Color.Text.primary)
            }
            .opacity(opacity)
        }
        .onAppear {
            withAnimation(.easeIn(duration: 1.0)) {
                opacity = 1.0
            }
            
            // "Invisible loading state" logic
            Task {
                // 1. Resolve Tenant
                await tenantService.resolveTenant()
                // 2. Check Auth State (Simulated delay for UX)
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                
                // 3. Routing Logic
                // If first launch -> Onboarding
                // Else -> Main or Auth
                // For MVP, forced flow:
                
                if UserDefaults.standard.bool(forKey: "hasSeenOnboarding") {
                    appState.currentRoute = .authSelection
                } else {
                    appState.currentRoute = .onboarding
                }
            }
        }
    }
}
