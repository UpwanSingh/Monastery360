import Foundation

// Placeholder for FirebaseAnalytics or custom logging
// Keeps code decoupled from direct SDK calls

@Observable
class AnalyticsService {
    
    func logEvent(_ name: String, parameters: [String: Any]? = nil) {
        // Analytics.logEvent(name, parameters: parameters)
        print("[Analytics] Event: \(name) Params: \(String(describing: parameters))")
    }
    
    func logScreen(_ name: String) {
        // Analytics.logEvent(AnalyticsEventScreenView, ...)
        print("[Analytics] Screen: \(name)")
    }
    
    func setUserProperty(_ value: String?, forName name: String) {
        // Analytics.setUserProperty(value, forName: name)
    }
}
