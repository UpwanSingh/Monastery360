import Foundation
import SwiftUI

// MARK: - App State
// Manages global state: Auth Status, Navigation Root, System Status

@Observable
class AppState {
    
    enum AppRoute: Hashable {
        case splash
        case onboarding
        case authSelection
        case mainTab
    }
    
    // State Variables
    var currentRoute: AppRoute = .splash
    var isAuthenticated: Bool = false
    var isOffline: Bool = false
    
    // User Session
    var currentUser: User? = nil
    
    init() {
        // Initial checks would go here
    }
}
