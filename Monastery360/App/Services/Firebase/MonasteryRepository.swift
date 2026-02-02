import Foundation
import FirebaseFirestore
import CoreLocation
import Observation

@Observable
class MonasteryRepository {
    // Dependencies injected via init
    private let firestoreService: FirestoreService
    private let tenantService: TenantService
    
    init(firestoreService: FirestoreService, tenantService: TenantService) {
        self.firestoreService = firestoreService
        self.tenantService = tenantService
    }
    
    // Computed property for readability
    private var collectionPath: String {
        return "tenants/\(tenantService.currentTenantId)/monasteries"
    }
    
    // Direct db access is still needed until FirestoreService exposes a generic query interface.
    // Ideally FirestoreService should wrap this, but for Phase 1 we just inject the service
    // and access its db property if public, OR we use the service methods if available.
    // Looking at common patterns, we often expose `db` or use generic fetch methods.
    // Let's check FirestoreService first. If it's generic, we use it. If not, we fix it.
    // For now, assuming FirestoreService exposes `db` or we use it to get collections.
    
    var db: Firestore { firestoreService.db }
    
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
}

// MARK: - Mocks for UI Development
extension Monastery {
    static let mockRumtek = Monastery(
        id: "rumtek_1",
        name: LocalizedString(en: "Rumtek Monastery", bo: "རུམ་ཏེག་དགོན་པ།"),
        location: MonasteryLocation(lat: 27.3, lng: 88.6),
        geoHash: "t7r3",
        establishedYear: 1966,
        sectTradition: "Karma Kagyu",
        shortDesc: "Also called the Dharma Chakra Centre, is a gompa located in the Indian state of Sikkim.",
        fullHistory: "Long history...",
        architectureStyle: "Tibetan",
        tags: ["kagyu", "historic"],
        thumbnailUrl: "https://example.com/rumtek.jpg",
        panoramaUrl: "https://firebasestorage.googleapis.com/v0/b/monastery-360.appspot.com/o/tenants%2Fsikkim_tourism%2Fmonasteries%2Frumtek%2F360%2Fmain.jpg?alt=media",
        galleryUrls: [],
        audioGuideUrl: nil,
        visitorInfo: VisitorInfo(openingTime: "09:00", closingTime: "17:00", bestTime: "March", entryFee: 50, rules: [], photographyRules: "Restricted"),
        stats: MonasteryStats(views: 1200, rating: 4.8)
    )
    
    static let mockPemayangtse = Monastery(
        id: "pem_1",
        name: LocalizedString(en: "Pemayangtse Monastery", bo: nil),
        location: MonasteryLocation(lat: 27.3, lng: 88.2),
        geoHash: "t7r2",
        establishedYear: 1705,
        sectTradition: "Nyingma",
        shortDesc: "Planned, designed, and founded by Lama Lhatsun Chempo in 1705.",
        fullHistory: "Markdown...",
        architectureStyle: "Nyingma",
        tags: ["nyingma", "ancient"],
        thumbnailUrl: "https://example.com/pem.jpg",
        panoramaUrl: nil,
        galleryUrls: [],
        audioGuideUrl: nil,
        visitorInfo: nil,
        stats: MonasteryStats(views: 890, rating: 4.9)
    )
}
