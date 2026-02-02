import SwiftUI
import AuthenticationServices

struct AuthSelectionView: View {
    @Environment(AppState.self) var appState
    @Environment(\.diContainer) var di
    
    @State private var viewModel: AuthViewModel?
    @State private var showEmailLogin = false
    @State private var currentNonce: String?
    
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
                    if let vm = viewModel {
                        // Apple Sign In
                        SignInWithAppleButton(.continue) { request in
                            let nonce = CryptoUtils.randomNonceString()
                            currentNonce = nonce
                            request.requestedScopes = [.fullName, .email]
                            request.nonce = CryptoUtils.sha256(nonce)
                        } onCompletion: { result in
                            switch result {
                            case .success(let authorization):
                                if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                                    guard let nonce = currentNonce else {
                                        fatalError("Invalid state: A login callback was received, but no login request was sent.")
                                    }
                                    guard let appleIDToken = appleIDCredential.identityToken else {
                                        print("Unable to fetch identity token")
                                        return
                                    }
                                    guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                                        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                                        return
                                    }
                                    
                                    Task {
                                        if await vm.handleAppleSignIn(idToken: idTokenString, nonce: nonce, name: appleIDCredential.fullName) {
                                            // Managed in vm
                                        }
                                    }
                                }
                            case .failure(let error):
                                print("Apple Sign In Failed: \(error.localizedDescription)")
                            }
                        }
                        .frame(height: 50)
                        .cornerRadius(Radius.pill)
                        .padding(.horizontal, 2) // Match M360Button padding hack if any
                        
                        // Google Sign In
                        M360Button("Continue with Google", icon: "globe", style: .secondary, isLoading: vm.isLoading && vm.error == nil) {
                            Task { await vm.signInWithGoogle() }
                        }
                        
                        // Email Sign In
                        M360Button("Continue with Email", icon: "envelope", style: .secondary, isLoading: false) {
                            showEmailLogin = true
                        }

                        
                        // Guest Mode
                        M360Button("Continue as Guest", style: .text, isLoading: vm.isLoading) {
                            Task {
                                if await vm.signInAnonymously() {
                                    appState.isAuthenticated = true
                                    appState.currentRoute = .mainTab
                                }
                            }
                        }
                        
                        if let error = vm.error {
                            Text(error)
                                .style(Typography.caption)
                                .foregroundStyle(Color.State.error)
                                .multilineTextAlignment(.center)
                                .padding(.top, Space.sm)
                        }
                    }
                }
                .padding(.horizontal, Space.xl)
                .padding(.bottom, Space.xxl)
            }
        }
        .sheet(isPresented: $showEmailLogin) {
            if let vm = viewModel {
                EmailLoginView(viewModel: vm)
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
