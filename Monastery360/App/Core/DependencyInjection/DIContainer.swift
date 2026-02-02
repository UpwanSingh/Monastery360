import Foundation
import SwiftUI
import Observation

// MARK: - Dependency Container
// Central hub for all services (Firebase, Auth, Location, Analytics)

@Observable
class DIContainer {
    
    // Core Services
    let tenantService: TenantService
    
    // Feature Services (Lazy loaded or initialized with Core dependencies)
    let authService: AuthService
    let firestoreService: FirestoreService
    let storageService: StorageService
    let analyticsService: AnalyticsService
    let locationService: LocationService
    
    // Offline Manager (Now managed heavily by DI)
    let offlineManager: OfflineManager
    
    init() {
        // 1. Core Config
        self.tenantService = TenantService()
        
        // 2. Base Services
        self.authService = AuthService()
        self.firestoreService = FirestoreService()
        self.storageService = StorageService()
        self.analyticsService = AnalyticsService()
        self.locationService = LocationService()
        
        // 3. Dependent Services
        // Injecting dependencies manually here
        self.offlineManager = OfflineManager(storageService: self.storageService)
    }
    
    // For Previews/Tests
    init(mock: Bool) {
        self.tenantService = TenantService(initialTenantId: "mock_tenant")
        self.authService = AuthService()
        self.firestoreService = FirestoreService()
        self.storageService = StorageService()
        self.analyticsService = AnalyticsService()
        self.locationService = LocationService()
        self.offlineManager = OfflineManager(storageService: self.storageService)
    }
    
    static let preview = DIContainer(mock: true)
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
