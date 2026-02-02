import SwiftUI
import MapKit

struct MapView: View {
    @Environment(Router.self) var router
    @Environment(\.diContainer) var di
    
    @State private var viewModel: MapViewModel?
    @State private var showList = false
    
    var focusMonasteryId: String? = nil
    
    var body: some View {
        NavigationStack(path: Bindable(router).mapPath) {
            ZStack(alignment: .bottom) {
                if let vm = viewModel {
                    Map(position: Bindable(vm).cameraPosition) {
                        ForEach(vm.monasteries) { item in
                            Annotation(item.name.en, coordinate: CLLocationCoordinate2D(latitude: item.location.lat, longitude: item.location.lng)) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title)
                                    .foregroundStyle(Color.Brand.primary)
                                    .scaleEffect(vm.selectedMonastery?.id == item.id ? 1.5 : 1.0)
                                    .animation(.spring, value: vm.selectedMonastery)
                                    .onTapGesture {
                                        vm.selectMonastery(item)
                                    }
                            }
                        }
                    }
                    .mapControls {
                        MapUserLocationButton()
                        MapCompass()
                        MapScaleView()
                    }
                    .onTapGesture {
                        vm.clearSelection()
                    }
                    
                    // Selected Card Overlay
                    if let selected = vm.selectedMonastery {
                        MonasteryPreviewCard(monastery: selected, onNavigate: {
                            // Launch Apple Maps
                            let coordinate = CLLocationCoordinate2D(latitude: selected.location.lat, longitude: selected.location.lng)
                            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
                            mapItem.name = selected.name.en
                            mapItem.openInMaps()
                        }, onDetail: {
                            router.navigate(to: .monasteryDetail(id: selected.id ?? ""))
                        })
                        .padding()
                        .padding(.bottom, 60) // Space for FAB or TabBar
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    
                    // Map List FAB (Only if no selection)
                    if vm.selectedMonastery == nil {
                        Button(action: {
                            showList.toggle()
                        }) {
                            HStack {
                                Image(systemName: "list.bullet")
                                Text("List View")
                            }
                            .padding()
                            .background(Color.Surface.elevated)
                            .cornerRadius(Radius.pill)
                            .shadow(radius: 5)
                        }
                        .padding(.bottom, Space.xl)
                    }
                } else {
                    ProgressView()
                }
            }
            .withRouteHandler()
        }
        .onAppear {
            if viewModel == nil {
               let repo = MonasteryRepository(firestoreService: di.firestoreService, tenantService: di.tenantService)
               let vm = MapViewModel(repository: repo, tenantService: di.tenantService)
               self.viewModel = vm
               
               Task {
                   await vm.loadMonasteries()
                   if let focusId = focusMonasteryId {
                       // Find and select
                       if let match = vm.monasteries.first(where: { $0.id == focusId }) {
                           vm.selectMonastery(match)
                       }
                   }
               }
            }
        }
    }
}
