import SwiftUI

struct M360TextField: View {
    let title: String
    @Binding var text: String
    let icon: String?
    let isSecure: Bool
    
    init(_ title: String, text: Binding<String>, icon: String? = nil, isSecure: Bool = false) {
        self.title = title
        self._text = text
        self.icon = icon
        self.isSecure = isSecure
    }
    
    var body: some View {
        HStack(spacing: Space.md) {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundStyle(Color.Text.tertiary)
            }
            
            if isSecure {
                SecureField(title, text: $text)
            } else {
                TextField(title, text: $text)
            }
        }
        .padding()
        .background(Color.Surface.interaction)
        .cornerRadius(Radius.md)
        .foregroundStyle(Color.Text.primary)
    }
}
