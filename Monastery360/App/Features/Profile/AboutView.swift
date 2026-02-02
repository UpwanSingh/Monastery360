import SwiftUI

struct AboutView: View {
    @Environment(\.diContainer) var di
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Space.lg) {
                // Header
                HStack {
                    Image("bs_logo_small") // Assuming asset exists or use system
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .cornerRadius(Radius.md)
                    
                    VStack(alignment: .leading) {
                        Text("Monastery360")
                            .style(Typography.h2)
                        Text("Version \(appVersion)")
                            .style(Typography.bodyMd)
                            .foregroundStyle(Color.Text.secondary)
                    }
                }
                .padding(.bottom, Space.md)
                
                // Description
                Text("About the App")
                    .style(Typography.h3)
                
                Text("Monastery360 is a digital preservation initiative designed to document and showcase the rich heritage of Sikkim's monasteries. Explore high-resolution 360° panoramas, listen to audio guides, and learn about the history of these sacred sites.")
                    .style(Typography.bodyMd)
                    .foregroundStyle(Color.Text.secondary)
                
                // Credits
                Text("Credits")
                    .style(Typography.h3)
                
                VStack(alignment: .leading, spacing: Space.sm) {
                    CreditRow(role: "Developed by", name: "Team Upwan")
                    CreditRow(role: "Content & Research", name: "Sikkim Tourism Dept.")
                    CreditRow(role: "Photography", name: "360 Visuals Inc.")
                }
                
                // Contact
                Text("Contact Us")
                    .style(Typography.h3)
                
                Button(action: {
                    if let url = URL(string: "mailto:support@monastery360.com") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    HStack {
                        Image(systemName: "envelope.fill")
                        Text("support@monastery360.com")
                    }
                    .foregroundColor(Color.Brand.primary)
                }
                
                // Developer Options (For Data Seeding)
                Text("Developer Tools")
                    .style(Typography.h3)
                    .padding(.top, Space.lg)
                
                Button(action: {
                    Task {
                        try? await di.seedService.seedMonasteries()
                        print("Database seeded!")
                    }
                }) {
                    HStack {
                        Image(systemName: "server.rack")
                        Text("Seed Database (Populate Monasteries)")
                    }
                    .padding()
                    .background(Color.Surface.elevated)
                    .cornerRadius(Radius.md)
                }
                
                Spacer()
            }
            .padding(Space.lg)
        }
        .navigationTitle("About")
        .background(Color.Surface.base)
    }
}

struct CreditRow: View {
    let role: String
    let name: String
    
    var body: some View {
        HStack {
            Text(role)
                .style(Typography.note)
                .foregroundStyle(Color.Text.tertiary)
            Spacer()
            Text(name)
                .style(Typography.bodyMd)
                .fontWeight(.medium)
        }
    }
}
