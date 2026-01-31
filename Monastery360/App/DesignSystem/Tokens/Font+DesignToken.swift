import SwiftUI

// MARK: - Typography Tokens
// Follows design_system.md: 3.2 Typography Tokens

struct Typography {
    
    // Roles
    static let display = Font.system(size: 34, weight: .bold, design: .default)
    static let h1 = Font.system(size: 28, weight: .bold, design: .default)
    static let h2 = Font.system(size: 22, weight: .semibold, design: .default)
    static let h3 = Font.system(size: 20, weight: .semibold, design: .default)
    static let bodyLg = Font.system(size: 17, weight: .medium, design: .default)
    static let bodyMd = Font.system(size: 17, weight: .regular, design: .default)
    static let caption = Font.system(size: 15, weight: .regular, design: .default)
    static let note = Font.system(size: 13, weight: .regular, design: .default)
    
}

extension View {
    func style(_ font: Font) -> some View {
        self.font(font)
    }
}
