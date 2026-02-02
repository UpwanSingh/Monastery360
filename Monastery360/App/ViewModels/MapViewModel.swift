import SwiftUI
import MapKit
import Observation
import CoreLocation

@Observable
class MapViewModel {
    // State
    var monasteries: [Monastery] = []
    var selectedMonastery: Monastery?
    var cameraPosition: MapCameraPosition = .automatic
    var isLoading: Bool = false
    var error: String?
    
    // Dependencies
    private let repository: MonasteryRepository
    private let tenantService: TenantService
    
    init(repository: MonasteryRepository, tenantService: TenantService) {
        self.repository = repository
        self.tenantService = tenantService
    }
    
    func loadMonasteries() async {
        isLoading = true
        error = nil
        
        do {
            // In a real app, we might get user location here
            self.monasteries = try await repository.fetchNearby(lat: 27.5, lng: 88.5) // Sikkim approx center
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func selectMonastery(_ monastery: Monastery) {
        self.selectedMonastery = monastery
        // Optional: Animate camera to selection
        let coordinate = CLLocationCoordinate2D(latitude: monastery.location.lat, longitude: monastery.location.lng)
        self.cameraPosition = .region(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)))
    }
    
    func clearSelection() {
        self.selectedMonastery = nil
    }
}
