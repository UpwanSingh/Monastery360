import SwiftUI

// MARK: - Home Components

struct FeaturedHeroCard: View {
    let monastery: Monastery
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background Image
            Rectangle() // Placeholder for AsyncImage
                .fill(Color.gray.opacity(0.3))
                .overlay(
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                )
            
            // Gradient Overlay
            LinearGradient(
                colors: [.black.opacity(0.8), .transparent],
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
        .cornerRadius(Radius.lg)
        .shadow(radius: 5)
    }
}

struct MonasteryCompactCard: View {
    let monastery: Monastery
    
    var body: some View {
        VStack(alignment: .leading, spacing: Space.sm) {
            Rectangle() // Placeholder
                .fill(Color.gray.opacity(0.2))
                .frame(width: 160, height: 120)
                .cornerRadius(Radius.md)
                .overlay(Text("Img").foregroundStyle(.secondary))
            
            Text(monastery.name.en)
                .style(Typography.bodyLg)
                .lineLimit(1)
                .foregroundStyle(Color.Text.primary)
            
            HStack(spacing: 4) {
                Image(systemName: "mappin.circle.fill")
                    .font(.caption)
                Text("2.4 km") // Mock distance
                    .style(Typography.caption)
            }
            .foregroundStyle(Color.Text.secondary)
        }
        .frame(width: 160)
    }
}
