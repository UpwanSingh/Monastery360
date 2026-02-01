import SwiftUI

struct RouteHandler: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: RouterDestination.self) { dest in
                switch dest {
                case .monasteryDetail(let id):
                    MonasteryDetailView(monasteryId: id)
                case .experience360(let id):
                    // PanoramaView handles the 360 experience
                    // We wrap it in a ZStack or simple View
                    Experience360View(monasteryId: id)
                case .map(let focusId):
                    MapView(focusMonasteryId: focusId)
                case .saved:
                    SavedView()
                case .profile:
                    ProfileView()
                case .webView(let url, let title):
                    // WebView Implementation
                Text("Web View: \(url.absoluteString)")
                }
            }
    }
}

extension View {
    func withRouteHandler() -> some View {
        modifier(RouteHandler())
    }
}

// End of RouteHandler modules
