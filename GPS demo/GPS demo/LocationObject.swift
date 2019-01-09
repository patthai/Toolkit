//
//  LocationObject.swift
//  GPS demo
//
//  Created by pat pataranutaporn on 1/9/19.
//  Copyright © 2019 pat pataranutaporn. All rights reserved.
//

import Foundation
import UIKit

class UserSavedLocation {
    
    var LocationName: String
    var Lat: String
    var Lon: String
    
    init(Location: String, Lat : String, Lon: String)
    {
        self.LocationName = Location
        self.Lat = Lat
        self.Lon = Lon
        
    }
}
