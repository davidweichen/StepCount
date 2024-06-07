import Foundation
import CoreLocation
import Combine
//Code from https://medium.com/@desilio/getting-user-location-with-swiftui-1f79d23c2321
final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    @Published var lastKnownLocation: CLLocationCoordinate2D?
    var manager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?
    @Published var locationName: String? {
            didSet {
                cityNameChanged?()
            }
        }
        
    var cityNameChanged: (() -> Void)?
    func checkLocationAuthorization() {
        
        manager.delegate = self
        manager.startUpdatingLocation()
        
        switch manager.authorizationStatus {
        case .notDetermined://The user choose allow or denny your app to get the location yet
            manager.requestWhenInUseAuthorization()
            
        case .restricted://The user cannot change this app’s status, possibly due to active restrictions such as parental controls being in place.
            print("Location restricted")
            
        case .denied://The user dennied your app to get location or disabled the services location or the phone is in airplane mode
            print("Location denied")
            
        case .authorizedAlways://This authorization allows you to use all location services and receive location events whether or not your app is in use.
            print("Location authorizedAlways")
            
        case .authorizedWhenInUse://This authorization allows you to use all location services and receive location events only when your app is in use
            print("Location authorized when in use")
            lastKnownLocation = manager.location?.coordinate
            
        @unknown default:
            print("Location service disabled")
        
        }
    }
    func fetchCityName() {
            guard let location = lastKnownLocation else {
                print("Location not available")
                return
            }
            
            let geocoder = CLGeocoder()
            let locationToGeocode = CLLocation(latitude: location.latitude, longitude: location.longitude)
            
            geocoder.reverseGeocodeLocation(locationToGeocode) { placemarks, error in
                guard error == nil else {
                    print("Reverse geocoding error: \(error!.localizedDescription)")
                    return
                }
                
                guard let placemark = placemarks?.first else {
                    print("No placemarks found")
                    return
                }
                
                if let city = placemark.locality {
                    self.locationName = city
                } else {
                    print("City name not found")
                }
            }
        }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {//Trigged every time authorization status changes
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.first?.coordinate
        fetchCityName()
    }
    


}
