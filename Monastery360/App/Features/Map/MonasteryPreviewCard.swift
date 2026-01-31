import SwiftUI

struct MonasteryPreviewCard: View {
    let monastery: Monastery
    let onNavigate: () -> Void
    let onDetail: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Drag Handle
            Capsule()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 4)
                .padding(.top, 8)
            
            HStack(alignment: .top, spacing: Space.md) {
                // Thumbnail
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 100, height: 100) // Square
                    .cornerRadius(Radius.md)
                    .overlay(Image(systemName: "photo"))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(monastery.name.en)
                        .style(Typography.h3)
                        .lineLimit(2)
                    
                    Text(monastery.shortDesc)
                        .style(Typography.caption)
                        .foregroundStyle(Color.Text.secondary)
                        .lineLimit(2)
                    
                    if let dist = monastery.distance {
                        Label("\(String(format: "%.1f", dist)) km away", systemImage: "location")
                            .font(.caption)
                            .foregroundStyle(Color.Brand.secondary)
                            .padding(.top, 4)
                    }
                }
                Spacer()
            }
            .padding(Space.lg)
            
            // Actions
            HStack(spacing: Space.md) {
                M360Button("View Details", style: .secondary) {
                    onDetail()
                }
                M360Button("Navigate", icon: "arrow.triangle.turn.up.right.diamond.fill") {
                    onNavigate()
                }
            }
            .padding(.horizontal, Space.lg)
            .padding(.bottom, Space.xl) // Safe area buffer
        }
        .background(Color.Surface.elevated)
        .cornerRadius(Radius.lg)
        .shadow(radius: 10)
    }
}
