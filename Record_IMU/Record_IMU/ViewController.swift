//
//  ViewController.swift
//  Record_IMU
//
//  Created by pat pataranutaporn on 5/9/19.
//  Copyright © 2019 pat pataranutaporn. All rights reserved.
//

import UIKit
import CoreMotion



class ViewController: UIViewController {
    @IBOutlet weak var record_button: UIButton!
    @IBOutlet weak var reset_button: UIButton!
    @IBOutlet weak var record_duration: UITextField!
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var sampling_rate: UISegmentedControl!
    
    @IBOutlet weak var output: UITextView!
    var record_status = false
    var sampling_rate_value = 0.5
    
    var record_time = 0
    var record_duration_value = 100
    @IBOutlet weak var progress: UIProgressView!
    
    var record_IMU_data : [[Double]] = []
    let motionManager = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update_values()
        // Do any additional setup after loading the view.
    }

    @IBAction func press_record(_ sender: Any) {
        if (record_status == false){
            record_button.setTitle("Stop", for: [])
            record_status = true
            update_values()
            record_IMU_data = []
            start_motion_data()
            
        }
            
        else {
            stop_motion_data()

        }
    }
    
    @IBAction func press_reset(_ sender: Any) {
    }
    
    @IBAction func rate_button(_ sender: Any) {
        switch sampling_rate.selectedSegmentIndex
        {
        case 0:
            sampling_rate_value = 0.5
        case 1:
            sampling_rate_value = 0.1
        case 2:
            sampling_rate_value = 0.05
        default:
            break
        }
        update_values()
    }
    
    
    func update_values()
    {
        record_duration_value = Int(record_duration.text!) ?? 0
        record_duration.text = String(record_duration_value)
        print (record_status, record_duration_value, sampling_rate_value)
    }
    
    
    
    func start_motion_data()
    {
        var count = 0
        var uAX: Double = 0.0
        var uAY: Double = 0.0
        var uAZ: Double = 0.0
        var uGX: Double = 0.0
        var uGY: Double = 0.0
        var uGZ: Double = 0.0
        var time: Double = 0.0
        
        
        if motionManager.isDeviceMotionAvailable{
            motionManager.deviceMotionUpdateInterval = sampling_rate_value
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { (data, error) in
                // print(data)
                
                time = data?.timestamp ?? 0
                
                uAX = data?.userAcceleration.x ?? 0
                uAY = data?.userAcceleration.y ?? 0
                uAZ = data?.userAcceleration.z ?? 0
                uGX = data?.rotationRate.x ?? 0
                uGY = data?.rotationRate.y ?? 0
                uGZ = data?.rotationRate.z ?? 0
                //print (time, uAX, uAY, uAZ, uGX, uGY, uGZ)
                self.record_IMU_data.append([time, uAX, uAY, uAZ, uGX, uGY, uGZ])
                count = count + 1
            
                print(count, self.record_duration_value)
                
                if (count > self.record_duration_value)
                {
                    self.stop_motion_data()
                }
                
            }
        }
    }
    
    
    func stop_motion_data()
    {
        if motionManager.isDeviceMotionAvailable{
            motionManager.stopDeviceMotionUpdates()
        }
        self.record_button.setTitle("Record", for: [])
        self.record_status = false
        print (record_IMU_data)
        update_values()

    }
    
}

