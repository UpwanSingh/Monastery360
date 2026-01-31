import Foundation

// MARK: - Spacing & Radius Tokens
// Follows design_system.md: 3.3 & 3.4

struct Space {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
    static let xxxl: CGFloat = 64
}

struct Radius {
    static let sm: CGFloat = 4
    static let md: CGFloat = 8
    static let lg: CGFloat = 12
    static let pill: CGFloat = 999
}

struct Elevation {
    // Helper to apply strict shadows
    static let low: (color: String, radius: CGFloat, y: CGFloat) = ("ShadowColor", 4, 2)
    static let med: (color: String, radius: CGFloat, y: CGFloat) = ("ShadowColor", 8, 4)
    static let high: (color: String, radius: CGFloat, y: CGFloat) = ("ShadowColor", 16, 8)
}
