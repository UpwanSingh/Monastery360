import SwiftUI
import Observation

@Observable
class ProfileViewModel {
    // State
    var userName: String = "User"
    var userInitials: String = "US"
    
    // Dependencies
    private let authService: AuthService
    
    init(authService: AuthService) {
        self.authService = authService
        loadUserProfile()
    }
    
    func loadUserProfile() {
        if let user = authService.user {
            if user.isAnonymous {
                self.userName = "Guest Pilgrim"
                self.userInitials = "GP"
            } else {
                self.userName = user.displayName ?? "Pilgrim"
                // Simple initials extraction
                let initials = self.userName.components(separatedBy: " ")
                    .compactMap { $0.first }
                    .prefix(2)
                    .map { String($0) }
                    .joined()
                    .uppercased()
                self.userInitials = initials.isEmpty ? "P" : initials
            }
        }
    }
    
    func signOut() throws {
        try authService.signOut()
    }
}
