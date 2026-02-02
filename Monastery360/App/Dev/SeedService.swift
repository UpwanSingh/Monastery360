import Foundation
import FirebaseFirestore

class SeedService {
    private let db: Firestore
    private let tenantId: String
    
    init(firestoreService: FirestoreService, tenantService: TenantService) {
        self.db = firestoreService.db // Assuming accessing public db property or we'll derive it
        self.tenantId = tenantService.currentTenantId
    }
    
    // Direct init for ad-hoc usage if needed, but best to use DI
    init() {
        self.db = Firestore.firestore()
        self.tenantId = "sikkim" // Default
    }
    
    func seedMonasteries() async throws {
        let monasteries = [
            Monastery(
                id: nil, // Let Firestore generate ID or we can set strict ones
                name: LocalizedString(en: "Rumtek Monastery", bo: "རུམ་ཐེག་དགོན་པ།"),
                location: MonasteryLocation(lat: 27.3056, lng: 88.5864),
                geoHash: "tunc7x", // Approx
                establishedYear: 1966,
                sectTradition: "Karma Kagyu",
                shortDesc: "The largest monastery in Sikkim, home to the Golden Stupa of the 16th Karmapa.",
                fullHistory: """
                **Rumtek Monastery**, also called the **Dharma Chakra Centre**, is a gompa located in the Indian state of Sikkim near the capital Gangtok. It is a focal point for the sectarian tensions within the Karma Kagyu school of Tibetan Buddhism that characterize the Karmapa controversy.
                
                Originally built by the 9th Karmapa Wangchuk Dorje in 1740, Rumtek served as the main seat of the Karma Kagyu lineage in Sikkim for some time. But when the 16th Karmapa arrived in Sikkim in 1959 after fleeing Tibet, the monastery was in ruins. Despite being offered other sites, the Karmapa decided to rebuild Rumtek. To him, the site possessed many auspicious qualities and was surrounded by flowing streams, mountains behind, a snow range in front, and a river below. With the generosity and help of the Sikkim royal family and the Indian locals of Sikkim, it was rebuilt by the 16th Karmapa as his main seat in exile.
                """,
                architectureStyle: "Tibetan",
                tags: ["Kagyu", "Golden Stupa", "Black Hat", "Peace"],
                thumbnailUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Rumtek_Monastery_Gangtok_Sikkim.jpg/800px-Rumtek_Monastery_Gangtok_Sikkim.jpg",
                panoramaUrl: "https://thumbs.dreamstime.com/b/rumtek-monastery-360-degree-panorama-sikkim-india-105151528.jpg",
                galleryUrls: [
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Rumtek_Monastery_Gangtok_Sikkim.jpg/800px-Rumtek_Monastery_Gangtok_Sikkim.jpg",
                    "https://www.sikkimtourism.gov.in/Content/Images/Trekking/Rumtek/1.jpg"
                ],
                audioGuideUrl: nil,
                visitorInfo: VisitorInfo(
                    openingTime: "06:00",
                    closingTime: "18:00",
                    bestTime: "March to June, September to December",
                    entryFee: 10,
                    rules: ["Remove shoes before entering shrine", "No photography inside main prayer hall"],
                    photographyRules: "Allowed in courtyard, prohibited inside."
                ),
                stats: MonasteryStats(views: 1250, rating: 4.8),
                distance: nil
            ),
            
            Monastery(
                id: nil,
                name: LocalizedString(en: "Pemayangtse Monastery", bo: "པདྨ་ཡང་རྩེ།"),
                location: MonasteryLocation(lat: 27.3039, lng: 88.2508),
                geoHash: "tunc2b",
                establishedYear: 1705,
                sectTradition: "Nyingma",
                shortDesc: "One of the oldest and premier monasteries of Sikkim, 'Perfect Sublime Lotus'.",
                fullHistory: """
                **Pemayangtse Monastery** is a Buddhist monastery in Pemayangtse, near Pelling in the northeastern Indian state of Sikkim, located 140 kilometres (87 mi) west of Gangtok. Planned, designed and founded by **Lama Lhatsun Chempo** in 1705, it is one of the oldest and premier monasteries of Sikkim, also the most famous in west Sikkim.
                
                Pemayangtse means 'Perfect Sublime Lotus', and is said to represent one of the four plexus of the human body. With the Wahong Gompa and Choam Gompa, it forms a pilgrimage circuit.
                """,
                architectureStyle: "Traditional Tibetan",
                tags: ["Nyingma", "Lhatsun Chempo", "Ancient", "Pelling"],
                thumbnailUrl: "https://upload.wikimedia.org/wikipedia/commons/2/23/Pemayangtse_Monastery_Rabdentse.jpg",
                panoramaUrl: "https://c8.alamy.com/comp/R3W6E8/360-degree-panorama-of-pemayangtse-monastery-in-pelling-sikkim-india-R3W6E8.jpg",
                galleryUrls: [
                    "https://upload.wikimedia.org/wikipedia/commons/2/23/Pemayangtse_Monastery_Rabdentse.jpg",
                     "https://www.esikkimtourism.in/wp-content/uploads/2019/04/pemayangste-monastery.jpg"
                ],
                audioGuideUrl: nil,
                visitorInfo: VisitorInfo(
                    openingTime: "09:00",
                    closingTime: "17:00",
                    bestTime: "February for Cham Dance",
                    entryFee: 20,
                    rules: ["Silence maintained"],
                    photographyRules: "Restricted in upper floors"
                ),
                stats: MonasteryStats(views: 980, rating: 4.9),
                distance: nil
            ),
            
            Monastery(
                id: nil,
                name: LocalizedString(en: "Enchey Monastery", bo: "ཨེན་ཆེ་དགོན་པ།"),
                location: MonasteryLocation(lat: 27.3438, lng: 88.6212),
                geoHash: "tunck8",
                establishedYear: 1909,
                sectTradition: "Nyingma",
                shortDesc: "The 'Solitary Monastery' built on a ridge above Gangtok.",
                fullHistory: """
                **Enchey Monastery** was established in 1909 above Gangtok, the capital city of Sikkim via northeastern India. It belongs to the Nyingma order of Vajrayana Buddhism.
                
                The monastery is built on a stunning ridge with a view of the Kanchenjunga range. The literal meaning of Enchey Monastery is the "Solitary Monastery". Its sacredness is attributed to the belief that the protecting deities of Khangchendzonga and Yabdean – the protective deities of the place – reside in this monastery.
                """,
                architectureStyle: "Chinese Pagoda Style influence",
                tags: ["Nyingma", "Gangtok", "Mask Dance", "Viewpoint"],
                thumbnailUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Enchey_Monastery_Gangtok.jpg/800px-Enchey_Monastery_Gangtok.jpg",
                panoramaUrl: nil,
                galleryUrls: [
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Enchey_Monastery_Gangtok.jpg/800px-Enchey_Monastery_Gangtok.jpg"
                ],
                audioGuideUrl: nil,
                visitorInfo: VisitorInfo(
                    openingTime: "06:00",
                    closingTime: "18:00",
                    bestTime: "December (Detor Cham)",
                    entryFee: 0,
                    rules: nil,
                    photographyRules: "Allowed outside"
                ),
                stats: MonasteryStats(views: 850, rating: 4.6),
                distance: nil
            ),
            Monastery(
                id: nil,
                name: LocalizedString(en: "Tashiding Monastery", bo: "བཀྲ་ཤིས་ལྡིང་།"),
                location: MonasteryLocation(lat: 27.3050, lng: 88.2930),
                geoHash: "tunc2w",
                establishedYear: 1641,
                sectTradition: "Nyingma",
                shortDesc: "The most sacred monastery in Sikkim, 'The Devoted Central Glory'.",
                fullHistory: "Tashiding means 'The Devoted Central Glory' and the monastery by this name was founded in 1641 by Ngadak Sempa Chempo Phunshok Rigzing, who belonged to the Nyingma sect of Tibetan Buddhism...",
                architectureStyle: "Ancient",
                tags: ["Sacred", "Bumchu", "Stupa"],
                thumbnailUrl: "https://www.sikkimtourism.gov.in/Content/Images/Trekking/Tashiding/1.jpg",
                panoramaUrl: nil,
                galleryUrls: ["https://www.sikkimtourism.gov.in/Content/Images/Trekking/Tashiding/1.jpg"],
                audioGuideUrl: nil,
                visitorInfo: VisitorInfo(
                    openingTime: "07:00",
                    closingTime: "17:00",
                    bestTime: "March (Bumchu Festival)",
                    entryFee: 0,
                    rules: ["Strict purity rules during festival"],
                    photographyRules: nil
                ),
                stats: MonasteryStats(views: 1100, rating: 5.0),
                distance: nil
            )
        ]
        
        let collection = db.collection("tenants").document(tenantId).collection("monasteries")
        
        for var monastery in monasteries {
            // Check if exists by name to avoid dupes? Or just add.
            // For seeding, adding is risky if we spam. Let's use name as ID-ish or just random
            // Let's use a consistent ID based on name sanitization to allow re-seeding without dupes
            let id = monastery.name.en.lowercased().replacingOccurrences(of: " ", with: "_")
            monastery.id = id // Technically @DocumentID ignores this on write if we use addDocument, strictly we should use setData on a specific Ref
            
            try collection.document(id).setData(from: monastery)
            print("Seeded: \(monastery.name.en)")
        }
    }
}
