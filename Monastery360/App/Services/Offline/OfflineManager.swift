import SwiftUI

@Observable
class OfflineManager {
    // Static singleton REMOVED in favor of DI
    
    // Dependencies
    private let storageService: StorageService
    
    // Track downloaded monastery IDs
    var downloadedContent: Set<String> = []
    
    // Status
    var isDownloading: Bool = false
    var progress: Double = 0.0
    
    init(storageService: StorageService) {
        self.storageService = storageService
    }
    
    func downloadContent(for monastery: Monastery, tenantId: String) async {
        isDownloading = true
        progress = 0.0
        
        // 1. Determine assets to download dynamically
        var assets: [String] = []
        
        if !monastery.thumbnailUrl.isEmpty { assets.append("hero.webp") } // Standard name convention
        if let pano = monastery.panoramaUrl, !pano.isEmpty { assets.append("360/main.webp") }
        if let galleries = monastery.galleryUrls {
            for (index, _) in galleries.enumerated() {
                assets.append("gallery/\(index + 1).webp")
            }
        }
        
        let total = Double(assets.count)
        if total == 0 { 
            isDownloading = false
            return 
        }
        
        var current = 0.0
        
        do {
            for assetName in assets {
                // Construct Firebase Storage Path
                let path = "tenants/\(tenantId)/monasteries/\(monastery.id ?? "unknown")/\(assetName)"
                
                let data = try await storageService.downloadData(path: path)
                saveToDisk(data: data, tenantId: tenantId, monasteryId: monastery.id ?? "unknown", filename: assetName)
                
                current += 1.0
                progress = current / total
            }
            
            if let id = monastery.id {
                downloadedContent.insert(id)
            }
        } catch {
            print("Download failed: \(error)")
        }
        
        isDownloading = false
        progress = 0.0
    }
    
    // Save Data to Documents Directory
    private func saveToDisk(data: Data, tenantId: String, monasteryId: String, filename: String) {
        guard let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        // Structure: Documents/downloads/{tenantId}/{monasteryId}/{filename}
        let folder = docs.appendingPathComponent("downloads").appendingPathComponent(tenantId).appendingPathComponent(monasteryId)
        let fileURL = folder.appendingPathComponent(filename)
        
        do {
            try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
            // Handle subdirectories in filename (e.g. gallery/1.webp)
             let fileFolder = fileURL.deletingLastPathComponent()
             try FileManager.default.createDirectory(at: fileFolder, withIntermediateDirectories: true)
            
            try data.write(to: fileURL)
        } catch {
            print("File save error: \(error)")
        }
    }
    
    func removeContent(for monasteryId: String, tenantId: String) {
        downloadedContent.remove(monasteryId)
         guard let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
         let folder = docs.appendingPathComponent("downloads").appendingPathComponent(tenantId).appendingPathComponent(monasteryId)
         try? FileManager.default.removeItem(at: folder)
    }
    
    func isDownloaded(_ id: String) -> Bool {
        return downloadedContent.contains(id)
    }
    
    func getSavedIds() -> [String] {
        return Array(downloadedContent)
    }
    
    // Helper to get local URL if exists
    func getLocalURL(for monasteryId: String, tenantId: String, filename: String) -> URL? {
        guard let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = docs.appendingPathComponent("downloads").appendingPathComponent(tenantId).appendingPathComponent(monasteryId).appendingPathComponent(filename)
        return FileManager.default.fileExists(atPath: fileURL.path) ? fileURL : nil
    }
}
