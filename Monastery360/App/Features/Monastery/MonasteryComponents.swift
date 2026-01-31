import SwiftUI

struct DetailOverviewView: View {
    let monastery: Monastery
    
    var body: some View {
        VStack(alignment: .leading, spacing: Space.lg) {
            Text(monastery.shortDesc)
                .style(Typography.bodyLg)
                .italic()
                .foregroundStyle(Color.Text.secondary)
            
            Divider()
            
            if let history = monastery.fullHistory {
                Text("History")
                    .style(Typography.h3)
                Text(history) // Markdown would go here
                    .style(Typography.bodyMd)
                    .foregroundStyle(Color.Text.primary)
            }
            
            if let arch = monastery.architectureStyle {
                Text("Architecture")
                    .style(Typography.h3)
                Text(arch)
                    .style(Typography.bodyMd)
            }
        }
        .padding(Space.lg)
    }
}

struct DetailGalleryView: View {
    let monastery: Monastery
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: Space.sm) {
            ForEach(0..<6, id: \.self) { _ in
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(1, contentMode: .fill)
                    .cornerRadius(Radius.md)
                    .overlay(Image(systemName: "photo"))
            }
        }
        .padding(Space.lg)
    }
}

struct DetailInfoView: View {
    let monastery: Monastery
    
    var body: some View {
        VStack(spacing: Space.md) {
            if let info = monastery.visitorInfo {
                InfoRow(icon: "clock", label: "Opening Hours", value: "\(info.openingTime) - \(info.closingTime)")
                InfoRow(icon: "banknote", label: "Entry Fee", value: "₹\(info.entryFee ?? 0)")
                if let bestTime = info.bestTime {
                    InfoRow(icon: "calendar", label: "Best Time", value: bestTime)
                }
                if let photoRules = info.photographyRules {
                    InfoRow(icon: "camera.badge.ellipsis", label: "Photography", value: photoRules)
                }
            } else {
                Text("Visitor information not available")
                    .style(Typography.bodyMd)
                    .foregroundStyle(Color.Text.secondary)
            }
        }
        .padding(Space.lg)
    }
}

struct InfoRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(Color.Brand.secondary)
                .frame(width: 24)
            Text(label).style(Typography.bodyMd).bold()
            Spacer()
            Text(value).style(Typography.bodyMd).foregroundStyle(Color.Text.secondary)
        }
        .padding()
        .background(Color.Surface.secondary)
        .cornerRadius(Radius.md)
    }
}
