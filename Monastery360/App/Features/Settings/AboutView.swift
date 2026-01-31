import SwiftUI

struct AboutView: View {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    
    var body: some View {
        ScrollView {
            VStack(spacing: Space.xl) {
                // Logo
                Image(systemName: "building.columns.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(Color.Brand.primary)
                    .padding(.top, Space.xl)
                
                Text("Monastery 360")
                    .style(Typography.h1)
                
                Text("v\(appVersion)")
                    .style(Typography.caption)
                    .foregroundStyle(Color.Text.secondary)
                
                VStack(alignment: .leading, spacing: Space.lg) {
                    Text("About Project")
                        .style(Typography.h3)
                    
                    Text("This application is dedicated to the digital preservation of the sacred monasteries of Sikkim. Through immersive 360° technology, we aim to document the architecture, art, and spirit of these sanctuaries for future generations.")
                        .style(Typography.bodyMd)
                        .foregroundStyle(Color.Text.secondary)
                    
                    Text("Credits")
                        .style(Typography.h3)
                    
                    Text("Developed by the Monastery 360 Team.\nPhotography by [Partner Name].\nHistorical texts curated by [Dept of Culture].")
                        .style(Typography.bodyMd)
                        .foregroundStyle(Color.Text.secondary)
                }
                .padding(Space.lg)
                
                Spacer()
                
                Text("© 2026 Monastery 360 Project")
                    .style(Typography.caption)
                    .foregroundStyle(Color.Text.tertiary)
                    .padding(.bottom, Space.xl)
            }
        }
        .background(Color.Surface.base)
        .navigationTitle("About")
    }
}
