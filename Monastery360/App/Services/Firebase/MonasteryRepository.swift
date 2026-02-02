import Foundation
import FirebaseFirestore
import CoreLocation
import Observation

@Observable
class MonasteryRepository {
    // Dependencies injected via init
    private let db: Firestore
    private let tenantService: TenantService
    
    init(firestoreService: FirestoreService, tenantService: TenantService) {
        // FirestoreService exposes the configured db instance
        self.db = firestoreService.db
        self.tenantService = tenantService
    }
    
    private var collectionPath: String {
        return "tenants/\(tenantService.currentTenantId)/monasteries"
    }
    
    func fetchMonastery(id: String) async throws -> Monastery? {
        let docRef = db.collection(collectionPath).document(id)
        let snapshot = try await docRef.getDocument()
        return try? snapshot.data(as: Monastery.self)
    }
    
    func fetchFeatured() async throws -> Monastery? {
        let snapshot = try await db.collection(collectionPath)
            .whereField("featured", isEqualTo: true)
            .limit(to: 1)
            .getDocuments()
            
        return try snapshot.documents.first?.data(as: Monastery.self)
    }
    
    func fetchNearby(lat: Double, lng: Double) async throws -> [Monastery] {
        // Real implementation: Fetch all and sort by distance locally (Production pattern for small datasets < 1000 docs)
        let snapshot = try await db.collection(collectionPath)
            .getDocuments()
            
        let all = snapshot.documents.compactMap { try? $0.data(as: Monastery.self) }
        
        // Simple distance sort
        let center = CLLocation(latitude: lat, longitude: lng)
        return all.sorted { m1, m2 in
            let l1 = CLLocation(latitude: m1.location.lat, longitude: m1.location.lng)
            let l2 = CLLocation(latitude: m2.location.lat, longitude: m2.location.lng)
            return l1.distance(from: center) < l2.distance(from: center)
        }
    }
    
    func fetchPopular() async throws -> [Monastery] {
         let snapshot = try await db.collection(collectionPath)
            .order(by: "stats.views", descending: true)
            .limit(to: 5)
            .getDocuments()
            
        return snapshot.documents.compactMap { try? $0.data(as: Monastery.self) }
    }
    
    func fetchAll() async throws -> [Monastery] {
        let snapshot = try await db.collection(collectionPath).getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: Monastery.self) }
    }
    
    func search(query: String) async throws -> [Monastery] {
        // Firestore doesn't support native full-text search.
        // Implemented client-side filter for efficiency given small dataset (<100 monasteries).
        // For production scale >1k docs, recommend migrating to Algolia/Typesense.
        let all = try await fetchAll()
        let lowerQuery = query.lowercased()
        
        return all.filter { monastery in
            monastery.name.en.lowercased().contains(lowerQuery) ||
            (monastery.tags.contains { $0.lowercased().contains(lowerQuery) }) ||
            (monastery.sectTradition?.lowercased().contains(lowerQuery) ?? false)
        }
    }
}

// MARK: - Production Ready
// No mock data extensions. All data strictly from Firestore.
