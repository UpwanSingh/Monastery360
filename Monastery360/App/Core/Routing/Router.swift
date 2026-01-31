import SwiftUI

// MARK: - App Router
// Handles deep linking and internal navigation paths

enum RouterDestination: Hashable {
    case monasteryDetail(id: String)
    case map(focusId: String?)
    case experience360(monasteryId: String)
    case saved
    case profile
    case webView(url: URL, title: String)
}


@Observable
class Router {
    var path = NavigationPath()
    
    func navigate(to destination: RouterDestination) {
        path.append(destination)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}
