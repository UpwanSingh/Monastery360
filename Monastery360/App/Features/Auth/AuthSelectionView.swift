import SwiftUI

struct AuthSelectionView: View {
    @Environment(AppState.self) var appState
    @Environment(\.diContainer) var di
    
    @State private var viewModel: AuthViewModel?
    
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
                    if let vm = viewModel, vm.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
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
                                if await viewModel?.signInAnonymously() == true {
                                    appState.isAuthenticated = true
                                    appState.currentRoute = .mainTab
                                }
                            }
                        }) {
                            Text("Continue as Guest")
                                .style(Typography.bodyMd)
                                .foregroundStyle(Color.Text.secondary)
                        }
                        .padding(.top, Space.sm)
                        
                        if let error = viewModel?.error {
                            Text(error)
                                .style(Typography.caption)
                                .foregroundStyle(.red)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .padding(.horizontal, Space.xl)
                .padding(.bottom, Space.xxl)
            }
        }
        .onAppear {
            if viewModel == nil {
                self.viewModel = AuthViewModel(authService: di.authService)
            }
        }
    }
}
#Preview {
    AuthSelectionView()
}
