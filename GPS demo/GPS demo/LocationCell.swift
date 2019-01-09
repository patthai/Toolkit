//
//  LocationCell.swift
//  GPS demo
//
//  Created by pat pataranutaporn on 1/9/19.
//  Copyright © 2019 pat pataranutaporn. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {

    @IBOutlet weak var LocationName: UILabel!
    @IBOutlet weak var Lat: UILabel!
    @IBOutlet weak var Lon: UILabel!
    
    func setLocation(location: UserSavedLocation){
        LocationName.text = location.LocationName
        Lat.text = location.Lat
        Lon.text = location.Lon
    }

}
