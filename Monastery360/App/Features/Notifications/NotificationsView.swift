import SwiftUI

struct NotificationItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let time: String
    let icon: String
    let color: Color
}

struct NotificationsView: View {
    @Environment(\.dismiss) var dismiss
    
    // Hardcoded "Welcome" notifications for initial release feel
    let notifications = [
        NotificationItem(
            title: "Welcome to Monastery360",
            message: "Embark on your spiritual journey through the sacred monasteries of Sikkim. Start by exploring the 360° views.",
            time: "Just now",
            icon: "hand.wave.fill",
            color: Color.Brand.primary
        ),
        NotificationItem(
            title: "New Feature: Map View",
            message: "You can now toggle between list and map views to find sanctuaries near you.",
            time: "2 hours ago",
            icon: "map.fill",
            color: Color.Brand.secondary
        ),
        NotificationItem(
            title: "Tip of the Day",
            message: "Did you know? Rumtek Monastery is also known as the Dharma Chakra Centre.",
            time: "Yesterday",
            icon: "lightbulb.fill",
            color: Color.Brand.tertiary
        )
    ]
    
    var body: some View {
        NavigationStack {
            List(notifications) { item in
                HStack(alignment: .top, spacing: Space.md) {
                    Circle()
                        .fill(Color.Surface.interaction)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: item.icon)
                                .foregroundColor(item.color)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title)
                            .style(Typography.bodyMd)
                            .fontWeight(.semibold)
                        
                        Text(item.message)
                            .style(Typography.caption)
                            .foregroundStyle(Color.Text.secondary)
                        
                        Text(item.time)
                            .font(.caption2)
                            .foregroundStyle(Color.Text.tertiary)
                            .padding(.top, 4)
                    }
                }
                .padding(.vertical, 4)
                .listRowBackground(Color.Surface.base)
            }
            .listStyle(.plain)
            .navigationTitle("Notifications")
            .background(Color.Surface.base)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
