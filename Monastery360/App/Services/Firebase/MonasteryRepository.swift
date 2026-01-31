import Foundation
import FirebaseFirestore

@Observable
class MonasteryRepository {
    private let db = Firestore.firestore()
    
    func fetchFeatured() async throws -> Monastery {
        // Mock for Phase 3 build - replace with real query:
        // db.collection("tenants").document(tenantId).collection("monasteries").whereField("featured", isEqualTo: true)
        return .mockRumtek
    }
    
    func fetchNearby(lat: Double, lng: Double) async throws -> [Monastery] {
        // Mock logic
        return [.mockRumtek, .mockPemayangtse]
    }
    
    func fetchPopular() async throws -> [Monastery] {
        return [.mockPemayangtse, .mockRumtek]
    }
}

// MARK: - Mocks for UI Development
extension Monastery {
    static let mockRumtek = Monastery(
        id: "rumtek_1",
        name: LocalizedString(en: "Rumtek Monastery", bo: "རུམ་ཏེག་དགོན་པ།"),
        location: GeoPoint(lat: 27.3, lng: 88.6),
        geoHash: "t7r3",
        establishedYear: 1966,
        sectTradition: "Karma Kagyu",
        shortDesc: "Also called the Dharma Chakra Centre, is a gompa located in the Indian state of Sikkim.",
        fullHistory: "Long history...",
        architectureStyle: "Tibetan",
        tags: ["kagyu", "historic"],
        thumbnailUrl: "https://example.com/rumtek.jpg", // Placeholder
        galleryUrls: [],
        audioGuideUrl: nil,
        visitorInfo: VisitorInfo(openingTime: "09:00", closingTime: "17:00", bestTime: "March", entryFee: 50, rules: [], photographyRules: "Restricted"),
        stats: MonasteryStats(views: 1200, rating: 4.8)
    )
    
    static let mockPemayangtse = Monastery(
        id: "pem_1",
        name: LocalizedString(en: "Pemayangtse Monastery", bo: nil),
        location: GeoPoint(lat: 27.3, lng: 88.2),
        geoHash: "t7r2",
        establishedYear: 1705,
        sectTradition: "Nyingma",
        shortDesc: "Planned, designed, and founded by Lama Lhatsun Chempo in 1705.",
        fullHistory: "Markdown...",
        architectureStyle: "Nyingma",
        tags: ["nyingma", "ancient"],
        thumbnailUrl: "https://example.com/pem.jpg",
        galleryUrls: [],
        audioGuideUrl: nil,
        visitorInfo: nil,
        stats: MonasteryStats(views: 890, rating: 4.9)
    )
}
