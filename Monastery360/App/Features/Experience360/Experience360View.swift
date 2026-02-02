import SwiftUI

struct Experience360View: View {
    let monasteryId: String
    
    @Environment(Router.self) var router
    @Environment(\.diContainer) var di
    
    @State private var viewModel: Experience360ViewModel?
    @State private var showInfo = false
    
    var body: some View {
        ZStack {
            // 1. 360 Canvas
            if let vm = viewModel, let url = vm.panoramaUrl {
                // Binding to ViewModel state
                let gyroBinding = Binding(
                    get: { vm.isGyroEnabled },
                    set: { vm.isGyroEnabled = $0 }
                )
                
                PanoramaView(
                    imageUrl: url,
                    isGyroEnabled: gyroBinding
                )
                .ignoresSafeArea()
            } else if viewModel?.isLoading == true {
                ProgressView()
                    .tint(.white)
            } else {
                ContentUnavailableView(viewModel?.error ?? "Panorama Not Available", systemImage: "photo.badge.exclamationmark")
                    .foregroundStyle(.white)
            }
            
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
                    
                    Text(viewModel?.monastery?.name.en ?? "Loading...")
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
                    if let vm = viewModel {
                        Button(action: { vm.isGyroEnabled.toggle() }) {
                            Image(systemName: vm.isGyroEnabled ? "gyroscope" : "hand.draw")
                                .font(.title2)
                                .padding()
                                .background(.ultraThinMaterial, in: Circle())
                                .foregroundStyle(vm.isGyroEnabled ? Color.Brand.secondary : .white)
                        }
                    }
                }
                .padding(.bottom, Space.xl)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showInfo) {
            VStack(spacing: Space.lg) {
                Text(viewModel?.monastery?.name.en ?? "Scene Info").style(Typography.h2)
                Text(viewModel?.monastery?.shortDesc ?? "Loading details...")
                    .style(Typography.bodyMd)
                Spacer()
            }
            .padding(Space.lg)
            .presentationDetents([.medium, .fraction(0.3)])
        }
        .onAppear {
            if viewModel == nil {
                // In production, we assume DI Container has setup the Repo/Service
                // But specifically for Repository, we instantiate it with the Services
                let repo = MonasteryRepository(firestoreService: di.firestoreService, tenantService: di.tenantService)
                let vm = Experience360ViewModel(repository: repo, offlineManager: di.offlineManager, tenantService: di.tenantService)
                self.viewModel = vm
                
                Task {
                    await vm.loadPanorama(monasteryId: monasteryId)
                }
            }
        }
    }
}
