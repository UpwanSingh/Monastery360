import SwiftUI

// MARK: - Color Tokens
// Follows design_system.md: 3.1 Color Tokens

extension Color {
    
    struct Brand {
        // Default values - to be overridden by Tenant Theme Injection later
        static let primary = Color(hex: "#D32F2F") // Sikkim Red
        static let secondary = Color(hex: "#FFA000") // Gold
        static let tertiary = Color(hex: "#455A64") // Slate
    }
    
    struct Surface {
        static let base = Color("SurfaceBase")      // #FFFFFF / #000000
        static let secondary = Color("SurfaceSecondary") // #F5F5F5 / #1C1C1E
        static let elevated = Color("SurfaceElevated")   // #FFFFFF / #2C2C2E
        static let interaction = Color("SurfaceInteraction") // #F0F0F0 / #3A3A3C
    }
    
    struct Text {
        static let primary = Color("TextPrimary") // #111111 / #FFFFFF
        static let secondary = Color("TextSecondary") // #666666 / #EBEBF5 (60%)
        static let tertiary = Color("TextTertiary") // #999999 / #EBEBF5 (30%)
        static let inverse = Color("TextInverse") // #FFFFFF / #000000
    }
    
    struct State {
        static let success = Color.green
        static let warning = Color.orange
        static let error = Color.red
    }
    
    // Helper for Hex initialization
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
