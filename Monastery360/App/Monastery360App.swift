import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct Monastery360App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // Core State Objects
    @State private var appState = AppState()
    @State private var router = Router()
    @State private var authService = AuthService()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
                .environment(router)
                .environment(authService)
                .preferredColorScheme(.dark) // Enforce dark mode for premium feel
        }
    }
}
