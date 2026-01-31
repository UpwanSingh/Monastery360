import Foundation

@Observable
class AuthService {}

@Observable
class FirestoreService {}

@Observable
class StorageService {}

@Observable
class LocationService {}

@Observable
class TenantService {
    let firestore: FirestoreService
    init(firestore: FirestoreService) { self.firestore = firestore }
}

struct User: Identifiable {
    let id: String
    let name: String
}
