import SwiftUI
import FirebaseCore
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    return true
  }
  
  func application(_ app: UIApplication,
                   open url: URL,
                   options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
  }
}

@main
struct Monastery360App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // Core State Objects
    @State private var appState = AppState()
    @State private var router = Router()
    
    // Dependency Injection
    @State private var diContainer: DIContainer
    
    init() {
        FirebaseApp.configure()
        _diContainer = State(initialValue: DIContainer())
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
                .environment(router)
                // Main DI Injection
                .environment(\.diContainer, diContainer)
                // Backward compatibility (if any view still uses Environment lookups directly, though we refactored most)
                .environment(diContainer.authService)
                .preferredColorScheme(.light) // Enforce light mode for airy feel (User Request)
        }
    }
}
