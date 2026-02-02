import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn

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
    
    // MARK: - Sign In Methods
    
    func signInWithGoogle() async throws {
        isLoading = true
        defer { isLoading = false }
        
        // 1. Check for client ID
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw NSError(domain: "AuthService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Firebase Client ID not found."])
        }
        
        // 2. Create configuration
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // 3. Get root view controller
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            throw NSError(domain: "AuthService", code: -2, userInfo: [NSLocalizedDescriptionKey: "Root View Controller not found."])
        }
        
        // 4. Sign In
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        
        // 5. Authenticate with Firebase
        guard let idToken = result.user.idToken?.tokenString else {
            throw NSError(domain: "AuthService", code: -3, userInfo: [NSLocalizedDescriptionKey: "Failed to get Google ID Token."])
        }
        let accessToken = result.user.accessToken.tokenString
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        try await Auth.auth().signIn(with: credential)
    }
    
    func signInWithApple(idTokenString: String, nonce: String, fullName: PersonNameComponents?) async throws {
        isLoading = true
        defer { isLoading = false }
        
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
        
        let authResult = try await Auth.auth().signIn(with: credential)
        self.user = authResult.user
        
        // Update user name if provided (Apple only provides it on first sign in)
        if let nameComponents = fullName, self.user?.displayName == nil {
             let firstName = nameComponents.givenName ?? ""
             let lastName = nameComponents.familyName ?? ""
             let fullName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
             
             if !fullName.isEmpty {
                 let changeRequest = self.user?.createProfileChangeRequest()
                 changeRequest?.displayName = fullName
                 try? await changeRequest?.commitChanges()
             }
        }
        
        syncUserDocument(user: authResult.user)
    }
    
    func signInWithEmail(email: String, pass: String) async throws {
        isLoading = true
        defer { isLoading = false }
        try await Auth.auth().signIn(withEmail: email, password: pass)
    }
    
    func signUpWithEmail(email: String, pass: String) async throws {
        isLoading = true
        defer { isLoading = false }
        try await Auth.auth().createUser(withEmail: email, password: pass)
    }

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
