import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    init(icon: String, title: String, message: String, actionTitle: String? = nil, action: (() -> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: Space.lg) {
            Spacer()
            
            Image(systemName: icon)
                .font(.system(size: 60))
                .foregroundStyle(Color.Brand.tertiary.opacity(0.5))
            
            VStack(spacing: Space.sm) {
                Text(title)
                    .style(Typography.h3)
                    .foregroundStyle(Color.Text.primary)
                
                Text(message)
                    .style(Typography.bodyMd)
                    .foregroundStyle(Color.Text.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Space.xl)
            }
            
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.Brand.primary)
                }
                .padding(.top, Space.md)
            }
            
            Spacer()
        }
    }
}
