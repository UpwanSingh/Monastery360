import SwiftUI

struct Experience360View: View {
    let monasteryId: String
    @Environment(Router.self) var router
    private let repository = MonasteryRepository() // Direct instantiation as per pattern, or inject via DI if strictly needed.
    
    @State private var isGyroEnabled = true
    @State private var showInfo = false
    @State private var url: URL?
    @State private var monastery: Monastery?
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            // 1. 360 Canvas
            if let url = url {
                PanoramaView(
                    imageUrl: url,
                    isGyroEnabled: $isGyroEnabled
                )
                .ignoresSafeArea()
            } else if isLoading {
                ProgressView()
                    .tint(.white)
            } else {
                ContentUnavailableView("Panorama Not Available", systemImage: "photo.badge.exclamationmark")
                    .foregroundStyle(.white)
            }
            
            // ... strict fetch on appear
            // 2. HUD - Top
            VStack {
                HStack {
                    Button(action: { router.pop() }) {
                        Image(systemName: "xmark")
                            .padding()
                            .background(.ultraThinMaterial, in: Circle())
                            .foregroundStyle(.white)
                    }
                    Spacer()
                    
                    Text(monastery?.name.en ?? "Loading...") // Dynamic Scene Name
                        .style(Typography.h3)
                        .foregroundStyle(.white)
                        .shadow(radius: 2)
                    
                    Spacer()
                    
                    Button(action: { showInfo.toggle() }) {
                        Image(systemName: "info.circle")
                            .padding()
                            .background(.ultraThinMaterial, in: Circle())
                            .foregroundStyle(.white)
                    }
                }
                .padding()
                
                Spacer()
                
                // 3. HUD - Bottom
                HStack(spacing: Space.xl) {
                    // Scene Selector (Thumbnail strip would go here)
                    Spacer()
                    
                    // Controls
                    Button(action: { isGyroEnabled.toggle() }) {
                        Image(systemName: isGyroEnabled ? "gyroscope" : "hand.draw")
                            .font(.title2)
                            .padding()
                            .background(.ultraThinMaterial, in: Circle())
                            .foregroundStyle(isGyroEnabled ? Color.Brand.secondary : .white)
                    }
                }
                .padding(.bottom, Space.xl)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showInfo) {
            VStack(spacing: Space.lg) {
                Text(monastery?.name.en ?? "Scene Info").style(Typography.h2)
                Text(monastery?.shortDesc ?? "Loading details...")
                    .style(Typography.bodyMd)
                Spacer()
            }
            .padding(Space.lg)
            .presentationDetents([.medium, .fraction(0.3)])
        }
        .onAppear {
            loadPanorama()
        }
    }
    
    private func loadPanorama() {
        Task {
            do {
                if let fetched = try await repository.fetchMonastery(id: monasteryId) {
                    self.monastery = fetched
                    if let stringUrl = fetched.panoramaUrl, let u = URL(string: stringUrl) {
                        self.url = u
                    }
                }
                isLoading = false
            } catch {
                print("Failed to load 360 data: \(error)")
                isLoading = false
            }
        }
    }
}
