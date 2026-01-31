import Foundation
import FirebaseStorage
import UIKit

@Observable
class StorageService {
    
    private let storage = Storage.storage()
    
    // Fetch Download URL
    func getDownloadURL(for path: String) async throws -> URL {
        let ref = storage.reference(withPath: path)
        return try await ref.downloadURL()
    }
    
    // Download Data (for images/JSON in memory)
    func downloadData(path: String, maxSize: Int64 = 10 * 1024 * 1024) async throws -> Data {
        let ref = storage.reference(withPath: path)
        
        return try await withCheckedThrowingContinuation { continuation in
            ref.getData(maxSize: maxSize) { data, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data {
                    continuation.resume(returning: data)
                }
            }
        }
    }
    
    // Upload Data (Profile images etc)
    func upload(data: Data, path: String, metadata: [String: String]? = nil) async throws -> URL {
        let ref = storage.reference(withPath: path)
        
        let meta = StorageMetadata()
        if let customMeta = metadata {
            meta.customMetadata = customMeta
        }
        
        _ = try await ref.putDataAsync(data, metadata: meta)
        return try await ref.downloadURL()
    }
}
