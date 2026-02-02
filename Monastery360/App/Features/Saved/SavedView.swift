import SwiftUI

struct SavedView: View {
    @Environment(Router.self) var router
    @Environment(\.diContainer) var di
    
    @State private var viewModel: SavedViewModel?
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack(path: Bindable(router).savedPath) {
            VStack(spacing: 0) {
                Text("Your Collection").style(Typography.h3).padding()
                
                Picker("Tabs", selection: $selectedTab) {
                    Text("Favorites").tag(0)
                    Text("Downloads").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, Space.lg)
                .padding(.bottom, Space.md)
                
                if let vm = viewModel {
                    if vm.isLoading {
                        Spacer()
                        ProgressView()
                        Spacer()
                    } else if vm.savedMonasteries.isEmpty {
                        VStack(spacing: Space.md) {
                            Spacer()
                            Image(systemName: "bookmark.slash")
                                .font(.system(size: 50))
                                .foregroundStyle(Color.Text.tertiary)
                            Text("No saved sanctuaries yet.")
                                .style(Typography.bodyMd)
                                .foregroundStyle(Color.Text.secondary)
                            Spacer()
                        }
                    } else {
                        List {
                            ForEach(vm.savedMonasteries) { item in
                                DiscoveryRow(monastery: item)
                                    .onTapGesture {
                                        router.navigate(to: .monasteryDetail(id: item.id ?? ""))
                                    }
                                    .swipeActions(edge: .trailing) {
                                        Button(role: .destructive) {
                                            if let id = item.id {
                                                vm.removeSaved(id: id)
                                            }
                                        } label: {
                                            Label("Remove", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                        .listStyle(.plain)
                    }
                }
            }
            .withRouteHandler()
        }
        .onAppear {
            if viewModel == nil {
                let repo = MonasteryRepository(firestoreService: di.firestoreService, tenantService: di.tenantService)
                let vm = SavedViewModel(offlineManager: di.offlineManager, repository: repo, tenantService: di.tenantService)
                self.viewModel = vm
                
                Task {
                    await vm.loadSavedMonasteries()
                }
            } else {
                // Reload when appearing to keep in sync with deletions elsewhere
                Task {
                    await viewModel?.loadSavedMonasteries()
                }
            }
        }
    }
}
