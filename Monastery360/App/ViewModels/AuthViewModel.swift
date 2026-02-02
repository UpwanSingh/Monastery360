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
        isLoading = true
        error = nil
        
        do {
            try await authService.signInAnonymously()
            isLoading = false
            return true
        } catch {
            self.error = error.localizedDescription
            isLoading = false
            return false
        }
    }
}
