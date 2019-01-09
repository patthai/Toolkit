//
//  SecondViewController.swift
//  Location demo
//
//  Created by pat pataranutaporn on 1/6/19.
//  Copyright © 2019 pat pataranutaporn. All rights reserved.
//

import UIKit
import CoreLocation

class ReverseGeocodingViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet var latitudeTextField: UITextField!
    @IBOutlet var longitudeTextField: UITextField!
    
    @IBOutlet var geocodeButton: UIButton!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet var locationLabel: UILabel!
    lazy var geocoder = CLGeocoder()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        // Update View
        geocodeButton.isHidden = false
        activityIndicatorView.stopAnimating()
        
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
            locationLabel.text = "Unable to Find Address for Location"
            
        } else {
            if  wlet placemarks = placemarks, let placemark = placemarks.first {
                locationLabel.text = placemark.compactAddress
            } else {
                locationLabel.text = "No Matching Addresses Found"
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func geocode(_ sender: UIButton) {
        guard let latAsString = latitudeTextField.text, let lat = Double(latAsString) else { return }
        guard let lngAsString = longitudeTextField.text, let lng = Double(lngAsString) else { return }
        
        // Create Location
        let location = CLLocation(latitude: lat, longitude: lng)
        
        // Geocode Location
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            // Process Response
            self.processResponse(withPlacemarks: placemarks, error: error)
        }
        
        // Update View
        geocodeButton.isHidden = true
        activityIndicatorView.startAnimating()
        
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

