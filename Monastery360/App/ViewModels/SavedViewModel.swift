import SwiftUI
import Observation

@Observable
class SavedViewModel {
    // State
    var savedMonasteries: [Monastery] = []
    var isLoading: Bool = false
    var error: String?
    
    // Dependencies
    private let offlineManager: OfflineManager
    private let repository: MonasteryRepository
    private let tenantService: TenantService
    
    init(offlineManager: OfflineManager, repository: MonasteryRepository, tenantService: TenantService) {
        self.offlineManager = offlineManager
        self.repository = repository
        self.tenantService = tenantService
    }
    
    func loadSavedMonasteries() async {
        isLoading = true
        error = nil
        
        // 1. Get IDs from manager
        let ids = offlineManager.getSavedIds()
        
        if ids.isEmpty {
            self.savedMonasteries = []
            isLoading = false
            return
        }
        
        // 2. Fetch details for each ID
        // 2. Fetch details for each ID
        // Firestore caching provides offline access automatically.
        // Parallel fetch improves performance over sequential calls.
        
        var loaded: [Monastery] = []
        
        // Parallel fetch for efficiency (or use whereIn query if Repo supports it)
        await withTaskGroup(of: Monastery?.self) { group in
            for id in ids {
                group.addTask {
                    return try? await self.repository.fetchMonastery(id: id)
                }
            }
            
            for await monastery in group {
                if let m = monastery {
                    loaded.append(m)
                }
            }
        }
        
        self.savedMonasteries = loaded
        isLoading = false
    }
    
    func removeSaved(id: String) {
        offlineManager.removeContent(for: id, tenantId: tenantService.currentTenantId)
        // Refresh list locally
        if let index = savedMonasteries.firstIndex(where: { $0.id == id }) {
            savedMonasteries.remove(at: index)
        }
    }
}
