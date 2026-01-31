import Foundation
import SwiftUI

// MARK: - Dependency Container
// Central hub for all services (Firebase, Auth, Location, Analytics)

@Observable
class DIContainer {
    
    // Services
    let authService: AuthService
    let tenantService: TenantService
    let firestoreService: FirestoreService
    let storageService: StorageService
    let analyticsService: AnalyticsService
    let locationService: LocationService
    
    // Configuration
    var activeTenantId: String = "sikkim_tourism" // Default fallback for MVP/Guest
    
    init() {
        // Initialize services
        self.authService = AuthService()
        self.firestoreService = FirestoreService()
        self.storageService = StorageService()
        self.analyticsService = AnalyticsService()
        self.locationService = LocationService()
        self.tenantService = TenantService(firestore: firestoreService)
    }
    
    static let mock = DIContainer() // For previews
}

// Environment Key for SwiftUI Injection
struct DIContainerKey: EnvironmentKey {
    static let defaultValue: DIContainer = DIContainer()
}

extension EnvironmentValues {
    var diContainer: DIContainer {
        get { self[DIContainerKey.self] }
        set { self[DIContainerKey.self] = newValue }
    }
}
