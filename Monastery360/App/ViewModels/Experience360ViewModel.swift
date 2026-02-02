import SwiftUI
import Observation

@Observable
class Experience360ViewModel {
    // State
    var monastery: Monastery?
    var panoramaUrl: URL?
    var isGyroEnabled: Bool = true
    var isLoading: Bool = true
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
    
    func loadPanorama(monasteryId: String) async {
        isLoading = true
        error = nil
        
        do {
            if let fetched = try await repository.fetchMonastery(id: monasteryId) {
                self.monastery = fetched
                
                // Determine URL (Offline vs Online)
                if let url = determinePanoramaURL(for: fetched) {
                    self.panoramaUrl = url
                } else {
                    self.error = "No panorama available"
                }
            } else {
                self.error = "Monastery not found"
            }
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
    
    private func determinePanoramaURL(for monastery: Monastery) -> URL? {
        // 1. Check Offline
        if let id = monastery.id, 
           offlineManager.isDownloaded(id),
           let localUrl = offlineManager.getLocalURL(for: id, filename: "360/main.webp") {
            return localUrl
        }
        
        // 2. Fallback to Online
        if let stringUrl = monastery.panoramaUrl, let url = URL(string: stringUrl) {
            return url
        }
        
        return nil
    }
}
