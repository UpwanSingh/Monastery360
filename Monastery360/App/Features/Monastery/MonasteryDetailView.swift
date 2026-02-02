import SwiftUI

struct MonasteryDetailView: View {
    let monasteryId: String
    
    @Environment(Router.self) var router
    @Environment(\.diContainer) var di
    
    @State private var viewModel: MonasteryDetailViewModel?
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.Surface.base.ignoresSafeArea()
            
            if let vm = viewModel, let monastery = vm.monastery {
                ScrollView {
                    VStack(spacing: 0) {
                        // 1. Parallax Header
                        ZStack {
                            if let url = URL(string: monastery.thumbnailUrl) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image.resizable()
                                             .aspectRatio(contentMode: .fill)
                                             .frame(height: 300)
                                             .clipped()
                                    case .failure:
                                        Rectangle().fill(Color.Surface.secondary)
                                        Image(systemName: "photo").font(.largeTitle).foregroundStyle(.secondary)
                                    case .empty:
                                        Rectangle().fill(Color.Surface.secondary)
                                        ProgressView()
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            } else {
                                Rectangle()
                                    .fill(Color.Surface.secondary)
                                Image(systemName: "photo")
                                    .font(.system(size: 40))
                                    .foregroundStyle(Color.Text.tertiary)
                            }
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
                        
                        // 3. Primary Actions (Refactored to use ViewModel)
                        HStack(spacing: Space.md) {
                            ActionButton(icon: "camera.aperture", title: "360° Tour", primary: true) {
                                router.navigate(to: .experience360(monasteryId: monasteryId))
                            }
                            ActionButton(icon: "map", title: "Route", primary: false) {
                                router.navigate(to: .map(focusId: monasteryId))
                            }
                            
                            // Save Action
                            let isSaved = vm.isSaved
                            ActionButton(icon: isSaved ? "checkmark.circle.fill" : "arrow.down.circle", 
                                       title: isSaved ? "Saved" : "Save", 
                                       primary: false) {
                                Task {
                                    if isSaved {
                                        vm.removeOffline()
                                    } else {
                                        await vm.saveOffline()
                                    }
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
            } else if viewModel?.isLoading == true {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel?.error {
                VStack {
                    Text("Error").font(Typography.h3)
                    Text(error).font(Typography.bodyMd).foregroundStyle(Color.Text.secondary)
                    Button("Retry") {
                        Task { await viewModel?.loadMonastery(id: monasteryId) }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            // Back Button Overlay
            Button(action: { router.pop() }) {
                Image(systemName: "chevron.left")
                    .padding()
                    .background(.ultraThinMaterial, in: Circle())
                    .padding(.leading, Space.md)
                    .padding(.top, 50) 
            }
        }
        .navigationBarHidden(true)
            }
        }
        .task(id: monasteryId) {
            // Ensure data is loaded/reloaded if ID changes
            if viewModel == nil {
                 let repo = MonasteryRepository(firestoreService: di.firestoreService, tenantService: di.tenantService)
                 let vm = MonasteryDetailViewModel(repository: repo, offlineManager: di.offlineManager, tenantService: di.tenantService)
                 self.viewModel = vm
            }
            // Always ensure the VM loads the correct ID
            if let vm = viewModel, vm.monastery?.id != monasteryId {
                await vm.loadMonastery(id: monasteryId)
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
