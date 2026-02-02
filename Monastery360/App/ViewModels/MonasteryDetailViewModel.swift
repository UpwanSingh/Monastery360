import SwiftUI
import Observation

@Observable
class MonasteryDetailViewModel {
    // State
    var monastery: Monastery?
    var isLoading: Bool = false
    var error: String?
    
    // Dependencies
    private let repository: MonasteryRepository
    private let offlineManager: OfflineManager
    private let tenantService: TenantService
    
    init(repository: MonasteryRepository, offlineManager: OfflineManager, tenantService: TenantService) {
        self.repository = repository
        self.offlineManager = offlineManager
        self.tenantService = tenantService
    }
    
    func loadMonastery(id: String) async {
        isLoading = true
        error = nil
        
        do {
            if let fetched = try await repository.fetchMonastery(id: id) {
                self.monastery = fetched
            } else {
                self.error = "Monastery not found"
            }
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func saveOffline() async {
        guard let monastery = monastery else { return }
        await offlineManager.downloadContent(for: monastery, tenantId: tenantService.currentTenantId)
    }
    
    func removeOffline() {
        guard let id = monastery?.id else { return }
        offlineManager.removeContent(for: id)
    }
    
    var isSaved: Bool {
        guard let id = monastery?.id else { return false }
        return offlineManager.isDownloaded(id)
    }
}
