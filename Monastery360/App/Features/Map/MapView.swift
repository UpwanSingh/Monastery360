import SwiftUI
import MapKit
import Observation

struct MapView: View {
    @State private var position: MapCameraPosition = .automatic
    @State private var monasteries: [Monastery] = []
    @State private var repo = MonasteryRepository()
    @Environment(Router.self) var router
    var focusMonasteryId: String? = nil
    
    var body: some View {
        NavigationStack(path: Bindable(router).mapPath) {
            ZStack(alignment: .bottom) {
                Map(position: $position) {
                    ForEach(monasteries) { item in
                        Annotation(item.name.en, coordinate: CLLocationCoordinate2D(latitude: item.location.lat, longitude: item.location.lng)) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.title)
                                .foregroundStyle(Color.Brand.primary)
                                .onTapGesture {
                                    router.navigate(to: .monasteryDetail(id: item.id ?? ""))
                                }
                        }
                    }
                }
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                    MapScaleView()
                }
                
                // Map List FAB
                Button(action: {
                    // Toggle list view
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
            .withRouteHandler()
        }
        .onAppear {
            loadData()
        }
    }
    
    func loadData() {
        Task {
            monasteries = try! await repo.fetchNearby(lat: 0, lng: 0)
        }
    }
}
