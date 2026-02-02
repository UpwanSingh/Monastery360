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
    
    init(offlineManager: OfflineManager, repository: MonasteryRepository) {
        self.offlineManager = offlineManager
        self.repository = repository
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
        // Note: Ideally, we should fetch from LOCAL storage/cache first if fully offline.
        // The repository might need to support "fetchLocal" or we assume details are small enough to cache or we rely on the repository's caching.
        // For strictly offline verification, we need to ensure these Monastery objects can be reconstructed from disk or are cached in Firestore/Repo.
        // Current Repo implementation fetches from Firestore. If offline, Firestore has a cache.
        // Optimally: Repo should have `fetchMonasteries(ids: [String])`
        
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
        offlineManager.removeContent(for: id)
        // Refresh list locally
        if let index = savedMonasteries.firstIndex(where: { $0.id == id }) {
            savedMonasteries.remove(at: index)
        }
    }
}
