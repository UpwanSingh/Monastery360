import Foundation
import Observation

// MARK: - Tenant Configuration Service
// Manages the current tenant context for multi-tenancy support.

@Observable
class TenantService {
    
    // Current active tenant ID
    var currentTenantId: String
    
    // In the future, this could hold Theme, FeatureFlags, etc. for the tenant
    
    init(initialTenantId: String = "sikkim_tourism") {
        self.currentTenantId = initialTenantId
    }
    
    func switchTenant(to tenantId: String) {
        self.currentTenantId = tenantId
        // Notification or state change could trigger app reload if needed
    }
}
