//
//  LocationViewController.swift
//  GPS demo
//
//  Created by pat pataranutaporn on 1/9/19.
//  Copyright © 2019 pat pataranutaporn. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    
}

extension LocationViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return global.locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let location = global.locations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
        cell.setLocation(location: location)
        return cell
    }
    
    
    
}
