import SwiftUI
import Observation

@Observable
class AuthViewModel {
    // State
    enum LoadingState {
        case idle
        case google
        case apple
        case email
        case guest
    }
    
    var loadingState: LoadingState = .idle
    var error: String?
    
    // Dependencies
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
    }
    
    var isLoading: Bool {
        return loadingState != .idle
    }
    
    func signInAnonymously() async -> Bool {
        return await performAuthAction(type: .guest) {
            try await authService.signInAnonymously()
        }
    }
    
    func signInWithGoogle() async -> Bool {
        return await performAuthAction(type: .google) {
            try await authService.signInWithGoogle()
        }
    }
    
    func handleAppleSignIn(idToken: String, nonce: String, name: PersonNameComponents?) async -> Bool {
        return await performAuthAction(type: .apple) {
            try await authService.signInWithApple(idTokenString: idToken, nonce: nonce, fullName: name)
        }
    }
    
    func signInWithEmail(email: String, password: String) async -> Bool {
        return await performAuthAction(type: .email) {
            try await authService.signInWithEmail(email: email, pass: password)
        }
    }
    
    func signUpWithEmail(email: String, password: String) async -> Bool {
        return await performAuthAction(type: .email) {
            try await authService.signUpWithEmail(email: email, pass: password)
        }
    }
    
    private func performAuthAction(type: LoadingState, action: () async throws -> Void) async -> Bool {
        loadingState = type
        error = nil
        do {
            try await action()
            loadingState = .idle
            return true
        } catch {
            self.error = error.localizedDescription
            loadingState = .idle
            return false
        }
    }
}
