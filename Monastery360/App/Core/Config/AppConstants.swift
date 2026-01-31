import Foundation

enum AppConstants {
    enum Config {
        // Fallback or Initial Tenant
        static let defaultTenantId = "sikkim_tourism" 
    }
    
    enum Storage {
        static let maxDownloadSize: Int64 = 10 * 1024 * 1024 // 10MB
    }
}
