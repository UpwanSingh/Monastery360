import SwiftUI

// MARK: - Home Components

struct FeaturedHeroCard: View {
    let monastery: Monastery
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background Image
            if let url = URL(string: monastery.thumbnailUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        Rectangle().fill(Color.Surface.interaction)
                            .overlay(ProgressView())
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Rectangle().fill(Color.gray.opacity(0.3))
                            .overlay(Image(systemName: "photo").font(.largeTitle))
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: nil, height: 250) // Allow width to expand
                .clipped()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                    )
            }
            
            // Gradient Overlay
            LinearGradient(
                colors: [.black.opacity(0.8), .clear],
                startPoint: .bottom,
                endPoint: .center
            )
            
            // Content
            VStack(alignment: .leading, spacing: Space.xs) {
                Text("FEATURED")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.Brand.secondary)
                
                Text(monastery.name.en)
                    .style(Typography.h2)
                    .foregroundStyle(Color.Text.inverse)
                
                Text(monastery.shortDesc)
                    .style(Typography.bodyMd)
                    .foregroundStyle(Color.Text.inverse.opacity(0.9))
                    .lineLimit(2)
            }
            .padding(Space.lg)
        }
        .frame(height: 250)
        .cardStyle(radius: Radius.lg, elevation: 5, bg: .clear)
        .contentShape(Rectangle())
    }
}

struct MonasteryCompactCard: View {
    let monastery: Monastery
    
    var body: some View {
        VStack(alignment: .leading, spacing: Space.sm) {
            // Image
            Group {
                if let url = URL(string: monastery.thumbnailUrl) {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image.resizable().aspectRatio(contentMode: .fill)
                        } else if phase.error != nil {
                             Rectangle().fill(Color.gray.opacity(0.2)).overlay(Image(systemName: "photo"))
                        } else {
                             Rectangle().fill(Color.Surface.interaction)
                        }
                    }
                } else {
                     Rectangle().fill(Color.gray.opacity(0.2)).overlay(Image(systemName: "photo"))
                }
            }
            .frame(width: 160, height: 120)
            .clipped()
            .cornerRadius(Radius.md)
            
            Text(monastery.name.en)
                .style(Typography.bodyLg)
                .lineLimit(1)
                .foregroundStyle(Color.Text.primary)
            
            HStack(spacing: 4) {
                Image(systemName: "mappin.circle.fill")
                    .font(.caption)
                Text((monastery.distance != nil) ? String(format: "%.1f km", monastery.distance!) : "Sikkim")
                    .style(Typography.caption)
            }
            .foregroundStyle(Color.Text.secondary)
        }
        .frame(width: 160)
        .cardStyle(radius: Radius.md, elevation: 2, bg: .clear)
        .contentShape(Rectangle())
    }
}
