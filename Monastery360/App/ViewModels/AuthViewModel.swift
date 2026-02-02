import SwiftUI
import Observation

@Observable
class AuthViewModel {
    // State
    var isLoading: Bool = false
    var error: String?
    
    // Dependencies
    private let authService: AuthService
    // We could inject AppState here too if we want the VM to drive navigation,
    // but usually View drives navigation based on state changes.
    // However, AppState seems to be a global router/state object.
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    func signInAnonymously() async -> Bool {
        return await performAuthAction {
            try await authService.signInAnonymously()
        }
    }
    
    func signInWithGoogle() async -> Bool {
        return await performAuthAction {
            try await authService.signInWithGoogle()
        }
    }
    
    func handleAppleSignIn(idToken: String, nonce: String, name: PersonNameComponents?) async -> Bool {
        return await performAuthAction {
            try await authService.signInWithApple(idTokenString: idToken, nonce: nonce, fullName: name)
        }
    }
    
    func signInWithEmail(email: String, password: String) async -> Bool {
        return await performAuthAction {
            try await authService.signInWithEmail(email: email, pass: password)
        }
    }
    
    func signUpWithEmail(email: String, password: String) async -> Bool {
        return await performAuthAction {
            try await authService.signUpWithEmail(email: email, pass: password)
        }
    }
    
    // Removed Simulator Placeholder Helper
    
    private func performAuthAction(_ action: () async throws -> Void) async -> Bool {
        isLoading = true
        error = nil
        do {
            try await action()
            isLoading = false
            return true
        } catch {
            self.error = error.localizedDescription
            isLoading = false
            return false
        }
    }
}
