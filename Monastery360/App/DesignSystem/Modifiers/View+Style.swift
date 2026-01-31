import SwiftUI

// MARK: - View Modifiers & Extensions
// Follows design_system.md

extension View {
    /// Applies a standard Typography token to the view.
    func style(_ font: Font) -> some View {
        self.font(font)
    }
}
