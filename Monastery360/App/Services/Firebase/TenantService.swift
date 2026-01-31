import Foundation
import FirebaseFirestore

// MARK: - Tenant Service (Critical System)
// Resolves the active tenant for the multi-tenant architecture.
// Mandated path: /tenants/{tenantId}/...

@Observable
class TenantService {
    
    // Core property: The filtered scope for all app operations
    var tenantId: String = "sikkim_tourism" // Default / Fallback
    
    private let firestore: FirestoreService
    
    init(firestore: FirestoreService) {
        self.firestore = firestore
    }
    
    func resolveTenant() async {
        // In a real multi-tenant app, this might come from:
        // 1. App Configuration (Remote Config)
        // 2. Deep Link subdomain
        // 3. User selection
        
        // For Phase 3 MVP, we enforce the Primary Tenant.
        // This could be fetched from global_config/app if needed.
        self.tenantId = "sikkim_tourism"
        print("Tenant Resolved: \(self.tenantId)")
    }
}
