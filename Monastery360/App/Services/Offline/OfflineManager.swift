import SwiftUI

@Observable
class OfflineManager {
    static let shared = OfflineManager()
    
    // Dependencies
    private let storageService = StorageService()
    
    // Track downloaded monastery IDs
    var downloadedContent: Set<String> = []
    
    // Status
    var isDownloading: Bool = false
    var progress: Double = 0.0
    
    func downloadContent(for monasteryId: String, tenantId: String) async {
        isDownloading = true
        progress = 0.0
        
        // 1. Determine assets to download (Mock list for MVP)
        // In a real app, we'd fetch the Monastery object first to get the list of paths.
        // Paths match Storage: tenants/{tenantId}/monasteries/{monasteryId}/...
        
        let assets = [
            "hero.webp",
            "gallery/1.webp",
            "360/main.webp"
        ]
        
        let total = Double(assets.count)
        var current = 0.0
        
        do {
            for assetName in assets {
                // Construct Firebase Storage Path
                // tenants/sikkim_tourism/monasteries/rumtek/hero.webp
                let path = "tenants/\(tenantId)/monasteries/\(monasteryId)/\(assetName)"
                
                let data = try await storageService.downloadData(path: path)
                saveToDisk(data: data, monasteryId: monasteryId, filename: assetName)
                
                current += 1.0
                progress = current / total
            }
            
            downloadedContent.insert(monasteryId)
        } catch {
            print("Download failed: \(error)")
        }
        
        isDownloading = false
        progress = 0.0
    }
    
    // Save Data to Documents Directory
    private func saveToDisk(data: Data, monasteryId: String, filename: String) {
        guard let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        // Structure: Documents/downloads/{monasteryId}/{filename}
        let folder = docs.appendingPathComponent("downloads").appendingPathComponent(monasteryId)
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
    
    func removeContent(for monasteryId: String) {
        downloadedContent.remove(monasteryId)
         guard let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
         let folder = docs.appendingPathComponent("downloads").appendingPathComponent(monasteryId)
         try? FileManager.default.removeItem(at: folder)
    }
    
    func isDownloaded(_ id: String) -> Bool {
        return downloadedContent.contains(id)
    }
    
    // Helper to get local URL if exists
    func getLocalURL(for monasteryId: String, filename: String) -> URL? {
        guard let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = docs.appendingPathComponent("downloads").appendingPathComponent(monasteryId).appendingPathComponent(filename)
        return FileManager.default.fileExists(atPath: fileURL.path) ? fileURL : nil
    }
}
