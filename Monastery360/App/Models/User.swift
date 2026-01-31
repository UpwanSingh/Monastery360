import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
    @DocumentID var id: String?
    let email: String?
    let role: UserRole
    let tenantId: String
    let preferences: UserPreferences?
    let lastLogin: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case role
        case tenantId
        case preferences
        case lastLogin = "last_login"
    }
}

enum UserRole: String, Codable {
    case superAdmin = "super_admin"
    case tenantAdmin = "tenant_admin"
    case editor = "editor"
    case user = "user"
    case guest = "guest"
}

struct UserPreferences: Codable {
    let language: String
    let notificationsEnabled: Bool
}
