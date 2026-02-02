import SwiftUI

struct EmailLoginView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(AppState.self) var appState
    
    // We inject ViewModel primarily to access the service, 
    // but usually we might create a local @State wrapper or pass it in.
    // Let's pass the Service dependence directly or reuse AuthViewModel if suitable.
    // Reuse AuthViewModel to keep logic centralized.
    @State var viewModel: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUp = false
    
    var body: some View {
        VStack(spacing: Space.lg) {
            // Header
            Text(isSignUp ? "Create Account" : "Sign In")
                .style(Typography.h2)
            
            // Fields
            VStack(spacing: Space.md) {
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color.Surface.interaction)
                    .cornerRadius(Radius.md)
                
                SecureField("Password", text: $password)
                    .textContentType(isSignUp ? .newPassword : .password)
                    .padding()
                    .background(Color.Surface.interaction)
                    .cornerRadius(Radius.md)
            }
            .padding(.horizontal)
            
            if let error = viewModel.error {
                Text(error)
                    .style(Typography.caption)
                    .foregroundStyle(Color.State.error)
            }
            
            // Action Button
            M360Button(isSignUp ? "Sign Up" : "Sign In", style: .primary, isLoading: viewModel.isLoading) {
                Task {
                    let success = isSignUp 
                        ? await viewModel.signUpWithEmail(email: email, password: password)
                        : await viewModel.signInWithEmail(email: email, password: password)
                    
                    if success {
                        appState.isAuthenticated = true
                        appState.currentRoute = .mainTab
                    }
                }
            }
            .padding(.horizontal)
            .disabled(email.isEmpty || password.isEmpty)
            .opacity(email.isEmpty || password.isEmpty ? 0.6 : 1)
            
            // Toggle
            Button(action: { isSignUp.toggle() }) {
                Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                    .style(Typography.bodyMd)
                    .foregroundStyle(Color.Brand.secondary)
            }
            
            Spacer()
        }
        .padding(.top, Space.xl)
        .background(Color.Surface.base.ignoresSafeArea())
    }
}
