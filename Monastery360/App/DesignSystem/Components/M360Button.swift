import SwiftUI

struct M360Button: View {
    enum Style {
        case primary
        case secondary
        case text
    }
    
    let title: String
    let icon: String?
    let style: Style
    let isLoading: Bool
    let action: () -> Void
    
    init(_ title: String, icon: String? = nil, style: Style = .primary, isLoading: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.style = style
        self.isLoading = isLoading
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Space.sm) {
                if isLoading {
                    ProgressView()
                        .tint(style == .primary ? Color.Text.inverse : Color.Brand.primary)
                } else {
                    if let icon = icon {
                        Image(systemName: icon)
                    }
                    Text(title)
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Space.md)
            .background(backgroundColor)
            .foregroundStyle(foregroundColor)
            .cornerRadius(Radius.pill)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.pill)
                    .stroke(borderColor, lineWidth: 1)
            )
        }
        .disabled(isLoading)
        .opacity(isLoading ? 0.7 : 1.0)
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary: return Color.Brand.primary
        case .secondary: return Color.clear
        case .text: return Color.clear
        }
    }
    
    private var foregroundColor: Color {
        switch style {
        case .primary: return Color.Text.inverse
        case .secondary: return Color.Brand.primary
        case .text: return Color.Text.secondary
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .primary: return Color.clear
        case .secondary: return Color.Brand.primary
        case .text: return Color.clear
        }
    }
}
