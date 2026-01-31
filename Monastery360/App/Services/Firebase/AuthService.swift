import Foundation
import FirebaseAuth
import FirebaseFirestore

@Observable
class AuthService {
    
    var user: FirebaseAuth.User?
    var isLoading: Bool = false
    var error: Error?
    
    init() {
        // Listen to Auth State Changes
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if let user = user {
                self?.user = user
                // Sync with Firestore User Document if needed - Phase 3 Requirement
                self?.syncUserDocument(user: user)
            } else {
                self?.user = nil
            }
        }
    }
    
    // MARK: - Sign In Methods
    
    func signInAnonymously() async throws {
        isLoading = true
        defer { isLoading = false }
        do {
            try await Auth.auth().signInAnonymously()
        } catch {
            self.error = error
            throw error
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    // MARK: - Internal
    
    private func syncUserDocument(user: FirebaseAuth.User) {
        // In a real app, check if doc exists, if not create it at /users/{uid}
        // This ensures the "User record created" requirement is met.
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)
        
        userRef.setData([
            "last_login": FieldValue.serverTimestamp(),
            "uid": user.uid,
            "is_anonymous": user.isAnonymous
        ], merge: true)
    }
}
