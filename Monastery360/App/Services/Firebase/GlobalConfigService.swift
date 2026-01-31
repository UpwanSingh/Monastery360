import Foundation
import FirebaseFirestore

struct AppConfig: Codable {
    let maintenanceMode: Bool
    let minVersion: String
    let announcement: String?
}

@Observable
class GlobalConfigService {
    private let db = Firestore.firestore()
    var config: AppConfig?
    
    func fetchConfig() async {
        do {
            let doc = try await db.collection("global_config").document("app").getDocument()
            self.config = try doc.data(as: AppConfig.self)
        } catch {
            print("Failed to fetch global config: \(error)")
        }
    }
}
