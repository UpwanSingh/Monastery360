import SwiftUI

struct MonasteryDetailView: View {
    let monasteryId: String
    @Environment(Router.self) var router
    @State private var monastery: Monastery?
    @State private var selectedTab = 0
    
    // Repository to fetch specific details
    @State private var repo = MonasteryRepository()
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.Surface.base.ignoresSafeArea()
            
            if let monastery = monastery {
                ScrollView {
                    VStack(spacing: 0) {
                        // 1. Parallax Header Placeholder
                        ZStack {
                            Rectangle()
                                .fill(Color.Surface.secondary)
                            Image(systemName: "photo")
                                .font(.system(size: 40))
                                .foregroundStyle(Color.Text.tertiary)
                        }
                        .frame(height: 300)
                        
                        // 2. Title Block
                        VStack(alignment: .leading, spacing: Space.sm) {
                            Text(monastery.name.en).style(Typography.h1)
                            if let bo = monastery.name.bo {
                                Text(bo).style(Typography.h2).foregroundStyle(Color.Text.secondary)
                            }
                            
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                Text("Sikkim, India")
                                Spacer()
                                Label("\(String(format: "%.1f", monastery.stats?.rating ?? 0))", systemImage: "star.fill")
                                    .foregroundStyle(Color.Brand.secondary)
                            }
                            .font(Typography.bodyMd)
                            .foregroundStyle(Color.Text.secondary)
                        }
                        .padding(Space.lg)
                        .background(Color.Surface.base)
                        // Sticky Header Logic usually involves GeometryReader, keeping simple for Phase 3 Codebase
                        
                        // 3. Primary Actions (Sticky-ish)
                        HStack(spacing: Space.md) {
                            ActionButton(icon: "camera.aperture", title: "360° Tour", primary: true) {
                                router.navigate(to: .experience360(monasteryId: monasteryId))
                            }
                            ActionButton(icon: "map", title: "Route", primary: false) {
                                router.navigate(to: .map(focusId: monasteryId))
                            }
                            ActionButton(icon: "arrow.down.circle", title: "Save", primary: false) {
                                Task {
                                    // Hardcoded tenant for now, but mechanism is real
                                    await OfflineManager.shared.downloadContent(for: monastery, tenantId: "sikkim_tourism")
                                }
                            }
                        }
                        .padding(.horizontal, Space.lg)
                        .padding(.bottom, Space.lg)
                        
                        // 4. Content Tabs
                        Picker("Tabs", selection: $selectedTab) {
                            Text("Overview").tag(0)
                            Text("Gallery").tag(1)
                            Text("Info").tag(2)
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal, Space.lg)
                        .padding(.bottom, Space.md)
                        
                        // 5. Tab Content
                        switch selectedTab {
                        case 0:
                            DetailOverviewView(monastery: monastery)
                        case 1:
                            DetailGalleryView(monastery: monastery)
                        case 2:
                            DetailInfoView(monastery: monastery)
                        default:
                            EmptyView()
                        }
                        
                        Spacer(minLength: 100)
                    }
                }
                .ignoresSafeArea(edges: .top)
            } else {
                ProgressView()
            }
            
            // Back Button Overlay
            Button(action: { router.pop() }) {
                Image(systemName: "chevron.left")
                    .padding()
                    .background(.ultraThinMaterial, in: Circle())
                    .padding(.leading, Space.md)
                    .padding(.top, 50) // Safe Area approximation
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            loadDetails()
        }
    }
    
    func loadDetails() {
        Task {
            do {
                if let fetched = try await repo.fetchMonastery(id: monasteryId) {
                    self.monastery = fetched
                } else {
                    print("Error: Monastery not found")
                    // Handle not found (go back or show error)
                }
            } catch {
                print("Error loading details: \(error.localizedDescription)")
            }
        }
    }
}

// Helper Components
struct ActionButton: View {
    let icon: String
    let title: String
    let primary: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                if primary { Text(title).fontWeight(.bold) }
            }
            .frame(maxWidth: .infinity)
            .standardButtonStyle(primary: primary)
        }
    }
}
