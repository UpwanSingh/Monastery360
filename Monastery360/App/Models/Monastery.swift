import Foundation
import FirebaseFirestore
import CoreLocation

// MARK: - Data Models
// Matches Firestore Schema from system_architecture.md

struct Monastery: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    let name: LocalizedString
    let location: GeoPoint
    let geoHash: String
    let establishedYear: Int?
    let sectTradition: String? // "Karma Kagyu"
    let shortDesc: String
    let fullHistory: String? // Markdown
    let architectureStyle: String?
    let tags: [String]
    let thumbnailUrl: String
    let galleryUrls: [String]?
    let audioGuideUrl: String?
    let visitorInfo: VisitorInfo?
    let stats: MonasteryStats?
    
    // Computed for UI
    var distance: Double? // In km, populated locally
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case location
        case geoHash = "geo_hash"
        case establishedYear = "established_year"
        case sectTradition = "sect_tradition"
        case shortDesc = "short_desc"
        case fullHistory = "full_history"
        case architectureStyle = "architecture_style"
        case tags
        case thumbnailUrl = "thumbnail_url"
        case galleryUrls = "gallery_urls"
        case audioGuideUrl = "audio_guide_url"
        case visitorInfo = "visitor_info"
        case stats
    }
    
    static func == (lhs: Monastery, rhs: Monastery) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct LocalizedString: Codable, Hashable {
    let en: String
    let bo: String? // Bodyig / Tibetan
}

struct GeoPoint: Codable, Hashable {
    let lat: Double
    let lng: Double
}

struct VisitorInfo: Codable, Hashable {
    let openingTime: String
    let closingTime: String
    let bestTime: String?
    let entryFee: Int?
    let rules: [String]?
    let photographyRules: String?
    
    enum CodingKeys: String, CodingKey {
        case openingTime = "opening_time"
        case closingTime = "closing_time"
        case bestTime = "best_time_to_visit"
        case entryFee = "entry_fee_inr"
        case rules = "entry_rules"
        case photographyRules = "photography_rules"
    }
}

struct MonasteryStats: Codable, Hashable {
    let views: Int
    let rating: Double
}
