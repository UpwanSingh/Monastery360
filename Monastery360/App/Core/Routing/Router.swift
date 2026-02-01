import SwiftUI
import Observation

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

enum AppTab: Hashable {
    case home, discovery, map, saved, profile
}


@Observable
class Router {
    // Independent stacks for each tab to preserve state
    var homePath = NavigationPath()
    var discoveryPath = NavigationPath()
    var mapPath = NavigationPath()
    var savedPath = NavigationPath()
    var profilePath = NavigationPath()
    
    // Active Tab tracking (synced with MainTabView)
    var selectedTab: AppTab = .home
    
    func navigate(to destination: RouterDestination) {
        // Append to the currently active path
        switch selectedTab {
        case .home: homePath.append(destination)
        case .discovery: discoveryPath.append(destination)
        case .map: mapPath.append(destination)
        case .saved: savedPath.append(destination)
        case .profile: profilePath.append(destination)
        }
    }
    
    func pop() {
        switch selectedTab {
        case .home: if !homePath.isEmpty { homePath.removeLast() }
        case .discovery: if !discoveryPath.isEmpty { discoveryPath.removeLast() }
        case .map: if !mapPath.isEmpty { mapPath.removeLast() }
        case .saved: if !savedPath.isEmpty { savedPath.removeLast() }
        case .profile: if !profilePath.isEmpty { profilePath.removeLast() }
        }
    }
    
    func popToRoot() {
        switch selectedTab {
        case .home: homePath = NavigationPath()
        case .discovery: discoveryPath = NavigationPath()
        case .map: mapPath = NavigationPath()
        case .saved: savedPath = NavigationPath()
        case .profile: profilePath = NavigationPath()
        }
    }
}
