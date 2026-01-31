import SwiftUI

// MARK: - Card Modifiers
// Follows design_system.md

struct CardModifier: ViewModifier {
    var radius: CGFloat
    var elevation: CGFloat
    var bg: Color
    
    func body(content: Content) -> some View {
        content
            .background(bg)
            .cornerRadius(radius)
            .shadow(radius: elevation)
    }
}

extension View {
    func cardStyle(radius: CGFloat = Radius.lg, elevation: CGFloat = 5, bg: Color = Color.Surface.base) -> some View {
        self.modifier(CardModifier(radius: radius, elevation: elevation, bg: bg))
    }
}
