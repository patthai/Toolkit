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
    @IBOutlet weak var timer_slider: UISlider!
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var sampling_rate: UITextField!
    
    var record_status = false
    var sampling_rate_value: Double = 0.5
    var record_duration_value: Double = 100
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
            start_motion_data()
        }
            
        else {
            record_button.setTitle("Record", for: [])
            record_status = false
            stop_motion_data()
            update_values()
        }
    }
    
    @IBAction func press_reset(_ sender: Any) {
    }
    
    func update_values()
    {
        sampling_rate_value = Double(sampling_rate.text!) as! Double
        record_duration_value = Double(record_duration.text!)as! Double
        
        sampling_rate.text = String(sampling_rate_value)
        record_duration.text = String(record_duration_value)
        print (record_status, record_duration_value, sampling_rate_value)
        
    }
    
    
    
    func start_motion_data()
    {
        var uAX: Double = 0.0
        var uAY: Double = 0.0
        var uAZ: Double = 0.0
        var uGX: Double = 0.0
        var uGY: Double = 0.0
        var uGZ: Double = 0.0
        var time: Double = 0.0
        
        
        if motionManager.isDeviceMotionAvailable{
            motionManager.deviceMotionUpdateInterval = 0.02
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { (data, error) in
                // print(data)
                
                time = data?.timestamp ?? 0
                
                uAX = data?.userAcceleration.x ?? 0
                uAY = data?.userAcceleration.y ?? 0
                uAZ = data?.userAcceleration.z ?? 0
                uGX = data?.rotationRate.x ?? 0
                uGY = data?.rotationRate.y ?? 0
                uGZ = data?.rotationRate.z ?? 0
                print (time, uAX, uAY, uAZ, uGX, uGY, uGZ)
            }
        }
    }
    
    
    func stop_motion_data()
    {
        if motionManager.isDeviceMotionAvailable{
            motionManager.stopDeviceMotionUpdates()
        }
    }
    
}

