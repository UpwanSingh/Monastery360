import SwiftUI

// MARK: - Button Modifiers
// Follows design_system.md

struct StandardButtonModifier: ViewModifier {
    var primary: Bool
    
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 12)
            .padding(.horizontal, Space.md)
            .background(primary ? Color.Brand.primary : Color.Surface.interaction)
            .foregroundStyle(primary ? Color.Text.inverse : Color.Text.primary)
            .cornerRadius(Radius.md)
    }
}

extension View {
    func standardButtonStyle(primary: Bool = true) -> some View {
        self.modifier(StandardButtonModifier(primary: primary))
    }
}
