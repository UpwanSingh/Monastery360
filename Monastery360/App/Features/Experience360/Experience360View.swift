import SwiftUI

struct Experience360View: View {
    let monasteryId: String
    @Environment(Router.self) var router
    @State private var isGyroEnabled = true
    @State private var showInfo = false
    
    var body: some View {
        ZStack {
            // 1. 360 Canvas
            PanoramaView(
                imageUrl: URL(string: "https://example.com/pano.jpg"), // Placeholder
                isGyroEnabled: $isGyroEnabled
            )
            .ignoresSafeArea()
            
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
                    
                    Text("Main Prayer Hall") // Dynamic Scene Name
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
                Text("About this Scene").style(Typography.h2)
                Text("This is the main prayer hall where monks gather twice daily...")
                    .style(Typography.bodyMd)
                Spacer()
            }
            .padding(Space.lg)
            .presentationDetents([.medium, .fraction(0.3)])
        }
    }
}
