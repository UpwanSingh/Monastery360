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
    
    private let locationService = LocationService() // Ideally injected or used via DI
    
    func loadMonasteries() async {
        isLoading = true
        error = nil
        
        do {
            // 1. Try to get user location
            var userLat = 27.5
            var userLng = 88.5
            
            do {
                let location = try await locationService.getCurrentLocation()
                userLat = location.coordinate.latitude
                userLng = location.coordinate.longitude
                
                // Update camera to user
                self.cameraPosition = .region(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
            } catch {
                print("Location unavailable, defaulting to Sikkim center")
            }
            
            // 2. Fetch nearby (Repository handles the distance sorting)
            self.monasteries = try await repository.fetchNearby(lat: userLat, lng: userLng)
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
