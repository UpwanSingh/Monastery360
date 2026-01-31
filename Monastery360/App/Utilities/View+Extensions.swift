import SwiftUI

// MARK: - Utilities
// Common extensions for the app

extension View {
    // Hide keyboard
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    // Standard Card Style
    func cardStyle() -> some View {
        self
            .background(Color.Surface.elevated)
            .cornerRadius(Radius.md)
            .shadow(color: Color(hex: "#000000").opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

extension Date {
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}
