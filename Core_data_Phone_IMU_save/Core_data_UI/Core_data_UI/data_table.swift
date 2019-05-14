//
//  ViewController.swift
//  coredata
//
//  Created by pat pataranutaporn on 3/21/19.
//  Copyright © 2019 pat pataranutaporn. All rights reserved.
//
import UIKit
import CoreData
import CoreMotion


class data_table: UIViewController {
 
    @IBOutlet weak var tableView: UITableView!

    var saved_record: [NSManagedObject] = []
     let motionManager = CMMotionManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "The List"
        tableView.register(UITableViewCell.self,forCellReuseIdentifier: "Cell")
         
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Record_event")
        do {
            saved_record = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        self.tableView.reloadData()
    }

    @IBAction func export(_ sender: Any) {
        print(saved_record.count)
        
        for data in saved_record as! [NSManagedObject] {
            var p_name = data.value(forKey: "name") as! String
            var p_activity = data.value(forKey: "activity") as! String
            var p_duration = data.value(forKey: "duration") as! String
            var p_sampling_rate = data.value(forKey: "sampling_rate") as! String
            var p_imu_data = data.value(forKey: "imu_data") as! String
        
            
            print(p_name, p_activity, p_duration, p_sampling_rate, p_imu_data)
        }
        
        export_to_csv()
    }
    
    func export_to_csv(){
        var file = "test"
        let fileName = "\(file).csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        var csvText = "name, activity class, duration, sampling rate, IMU data\n"
        
        
        if saved_record.count > 0 {
            
            for data in saved_record as! [NSManagedObject] {
                var p_name = data.value(forKey: "name") as! String
                var p_activity = data.value(forKey: "activity") as! String
                var p_duration = data.value(forKey: "duration") as! String
                var p_sampling_rate = data.value(forKey: "sampling_rate") as! String
                var p_imu_data = data.value(forKey: "imu_data") as! String
                
                
                print(p_name, p_activity, p_duration, p_sampling_rate, p_imu_data)
                
                let newLine = "\(p_name),\(p_activity),\(p_duration),\(p_sampling_rate),\(p_imu_data)\n"
                
                csvText = csvText + newLine
            }
            
            
            
            do {
                try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
                
                let vc = UIActivityViewController(activityItems: [path], applicationActivities: [])
                vc.excludedActivityTypes = [
                    UIActivity.ActivityType.assignToContact,
                    UIActivity.ActivityType.saveToCameraRoll,
                    UIActivity.ActivityType.postToFlickr,
                    UIActivity.ActivityType.postToVimeo,
                    UIActivity.ActivityType.postToTencentWeibo,
                    UIActivity.ActivityType.postToTwitter,
                    UIActivity.ActivityType.postToFacebook,
                    UIActivity.ActivityType.openInIBooks
                ]
                present(vc, animated: true, completion: nil)
                
            } catch {
                
                print("Failed to create file")
                print("\(error)")
            }
            
        }
    }

    
    
    
}

// MARK: - UITableViewDataSource
extension data_table: UITableViewDataSource {
    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        //print (saved_record.count)
        return saved_record.count
    
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let person = saved_record[indexPath.row]
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "Cell",
                                              for: indexPath)
            cell.textLabel?.text =
                person.value(forKeyPath: "name") as? String
            return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            
            //remove object from core data
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(saved_record[indexPath.row] as NSManagedObject)

            
            //update UI methods
            tableView.beginUpdates()
            saved_record.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            
            appDelegate.saveContext()
        }
    }
    
    
}

