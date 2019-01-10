import UIKit
import MapKit
import CoreLocation

struct global {
    static var user_lat = 0.0
    static var user_lon = 0.0
    static var locations: [UserSavedLocation] = []
}
class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var LocateMe_button: UIButton!

    @IBOutlet weak var coordination_label: UILabel!
    @IBOutlet weak var location_label: UILabel!
    
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
         global.locations = createArray()
        locateMe((Any).self)
        
    }
    
    func createArray() -> [UserSavedLocation]{
        var tempLocation: [UserSavedLocation] = []
        let home = UserSavedLocation(Location: "Home", Lat: "42.359870", Lon:"-71.102650" )
        let gym = UserSavedLocation(Location: "Gym", Lat: "42.361505", Lon:"-71.090588" )
        let work = UserSavedLocation(Location: "Work", Lat: "42.360380", Lon:"-71.087310" )
        
        tempLocation.append(home)
        tempLocation.append(gym)
        tempLocation.append(work)
        return tempLocation
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func locateMe(_ sender: Any) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        //manager.stopUpdatingLocation()
        
        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01,longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinations, span: span)
        
        global.user_lat = userLocation.coordinate.latitude
        global.user_lon = userLocation.coordinate.longitude
        
        //print (global.user_lat, global.user_lat)
        
        
        mapView.setRegion(region, animated: true)
        coordination_label.text = String(global.user_lat) + "," + String(global.user_lon)
        ClosestUserLocation()
        
        var geocoder = CLGeocoder()
        // Create Location
        let location = CLLocation(latitude: global.user_lat, longitude:  global.user_lon)
        
        // Geocode Location
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Unable to Reverse Geocode Location (\(error))")
                self.location_label.text = "Unable to Find Address for Location"
                
            } else {
                if let placemarks = placemarks, let placemark = placemarks.first {
                    self.location_label.text = placemark.compactAddress
                } else {
                    self.location_label.text = "No Matching Addresses Found"
                }
            }
        
        }
        
       
    }
    func ClosestUserLocation()
        {
            var least_distance = Float (1)
            var current_location = ""
            for searchlocation in global.locations{
                var lat_dif = Float(global.user_lat) - Float(searchlocation.Lat)!
                var lon_dif = Float(global.user_lon) - Float(searchlocation.Lon)!
                var distance = Float(hypotf(lat_dif, lon_dif))
                if (distance < least_distance) {
                    least_distance = distance
                    current_location = searchlocation.LocationName
                }
            
            }
        print(current_location)
        }
}

extension CLPlacemark {
    
    var compactAddress: String? {
        if let name = name {
            var result = name
            
            if let street = thoroughfare {
                result += ", \(street)"
            }
            
            if let city = locality {
                result += ", \(city)"
            }
            
            if let country = country {
                result += ", \(country)"
            }
            
            return result
        }
        
        return nil
    }
    
}


