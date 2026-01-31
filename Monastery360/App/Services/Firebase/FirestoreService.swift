import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

// MARK: - Firestore Service
// Handles generic data access with Tenant ID injection

@Observable
class FirestoreService {
    
    private let db = Firestore.firestore()
    
    // Core Fetch Method
    func getDocument<T: Decodable>(path: String, as type: T.Type) async throws -> T {
        let docRef = db.document(path)
        return try await docRef.getDocument(as: T.self)
    }
    
    // Core Collection Method
    func getCollection<T: Decodable>(path: String, type: T.Type, whereField: String? = nil, isEqualTo: Any? = nil) async throws -> [T] {
        var query: Query = db.collection(path)
        
        if let field = whereField, let value = isEqualTo {
            query = query.whereField(field, isEqualTo: value)
        }
        
        let snapshot = try await query.getDocuments()
        return try snapshot.documents.map { try $0.data(as: T.self) }
    }
    
    // Write Method
    func setData(path: String, data: [String: Any], merge: Bool = true) async throws {
        try await db.document(path).setData(data, merge: merge)
    }
    
    // Sub-collection Stream (Realtime)
    func listen<T: Decodable>(to path: String, type: T.Type, completion: @escaping ([T]) -> Void) -> ListenerRegistration {
        return db.collection(path).addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                return
            }
            let results = documents.compactMap { try? $0.data(as: T.self) }
            completion(results)
        }
    }
}
