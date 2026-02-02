import SwiftUI

struct AuthSelectionView: View {
    @Environment(AppState.self) var appState
    @Environment(DIContainer.self) var di
    
    var body: some View {
        ZStack {
            Color.Surface.base.ignoresSafeArea()
            
            VStack(spacing: Space.lg) {
                Spacer()
                
                Text("Welcome to\nMonastery 360")
                    .style(Typography.display)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                VStack(spacing: Space.md) {
                    // Apple Sign In (Placeholder Style)
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "apple.logo")
                            Text("Continue with Apple")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundStyle(.white)
                        .cornerRadius(Radius.pill)
                    }
                    
                    // Google Sign In (Placeholder Style)
                    Button(action: {}) {
                        HStack {
                            Text("G")
                                .bold()
                            Text("Continue with Google")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(Radius.pill)
                    }
                    
                    // Guest Mode
                    Button(action: {
                        Task {
                            try? await di.authService.signInAnonymously()
                            appState.isAuthenticated = true
                            appState.currentRoute = .mainTab
                        }
                    }) {
                        Text("Continue as Guest")
                            .style(Typography.bodyMd)
                            .foregroundStyle(Color.Text.secondary)
                    }
                    .padding(.top, Space.sm)
                }
                .padding(.horizontal, Space.xl)
                .padding(.bottom, Space.xxl)
            }
        }
    }
}
#Preview {
    AuthSelectionView()
}
