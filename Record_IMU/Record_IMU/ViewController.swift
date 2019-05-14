//
//  ViewController.swift
//  Record_IMU
//
//  Created by pat pataranutaporn on 5/9/19.
//  Copyright © 2019 pat pataranutaporn. All rights reserved.
//

import UIKit
import Charts
import CoreMotion



class ViewController: UIViewController {
    
    @IBOutlet weak var IMU_graph_view: LineChartView!
    @IBOutlet weak var Gyro_graph_view: LineChartView!

    
    @IBOutlet weak var record_button: UIButton!
    @IBOutlet weak var reset_button: UIButton!
    @IBOutlet weak var record_duration: UITextField!
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var sampling_rate: UISegmentedControl!
    
    var record_status = false
    var sampling_rate_value = 0.5
    
    var record_time = 0
    var record_duration_value = 100
    @IBOutlet weak var record_progress: UIProgressView!
    
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
        //print (record_status, record_duration_value, sampling_rate_value)
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
                
                
                self.timer.text = "Progress : " + String(count) + "/" + String(self.record_duration_value)
                if (count >= self.record_duration_value)
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
        //print (record_IMU_data)
        update_values()
        updateIMUGraph()
        updateGyroGraph()

    }
    
    func updateIMUGraph(){
        let data = LineChartData()
        
        var lineChartEntry0 = [ChartDataEntry]()
        var lineChartEntry1 = [ChartDataEntry]()
        var lineChartEntry2 = [ChartDataEntry]()
        
        for i in 0..<record_IMU_data.count {
            
            lineChartEntry0.append(ChartDataEntry(x: Double(i), y: Double(record_IMU_data[i][1]) ?? 0.0))
            let line0 = LineChartDataSet(entries: lineChartEntry0, label: "First Dataset")
            data.addDataSet(line0)
            line0.setColor(UIColor.red)
            line0.setCircleColor(UIColor.red)
            line0.lineWidth = 0.5
            line0.circleRadius = 0.6
            line0.fillColor = UIColor.red
            
            lineChartEntry1.append(ChartDataEntry(x: Double(i), y: Double(record_IMU_data[i][2]) ?? 0.0))
            let line1 = LineChartDataSet(entries: lineChartEntry1, label: "Second Dataset")
            data.addDataSet(line1)
            line1.setColor(UIColor.green)
            line1.setCircleColor(UIColor.green)
            line1.lineWidth = 0.5
            line1.circleRadius = 0.6
            line1.fillColor = UIColor.green
            
            lineChartEntry2.append(ChartDataEntry(x: Double(i), y: Double(record_IMU_data[i][3]) ?? 0.0))
            let line2 = LineChartDataSet(entries: lineChartEntry2, label: "Second Dataset")
            data.addDataSet(line2)
            line2.setColor(UIColor.blue)
            line2.setCircleColor(UIColor.blue)
            line2.lineWidth = 0.5
            line2.circleRadius = 0.6
            line2.fillColor = UIColor.blue
            
        }
        
        self.IMU_graph_view.data = data
        self.IMU_graph_view.legend.enabled = false
        self.IMU_graph_view.leftAxis.axisMaximum = 1.5;
        self.IMU_graph_view.leftAxis.axisMinimum = -1.5;
        
    }
    
    func updateGyroGraph(){
        let data = LineChartData()
        
        var lineChartEntry0 = [ChartDataEntry]()
        var lineChartEntry1 = [ChartDataEntry]()
        var lineChartEntry2 = [ChartDataEntry]()
        
        for i in 0..<record_IMU_data.count {
            
            lineChartEntry0.append(ChartDataEntry(x: Double(i), y: Double(record_IMU_data[i][4]) ?? 0.0))
            let line0 = LineChartDataSet(entries: lineChartEntry0, label: "First Dataset")
            data.addDataSet(line0)
            line0.setColor(UIColor.red)
            line0.setCircleColor(UIColor.red)
            line0.lineWidth = 0.5
            line0.circleRadius = 0.6
            line0.fillColor = UIColor.red
            
            lineChartEntry1.append(ChartDataEntry(x: Double(i), y: Double(record_IMU_data[i][5]) ?? 0.0))
            let line1 = LineChartDataSet(entries: lineChartEntry1, label: "Second Dataset")
            data.addDataSet(line1)
            line1.setColor(UIColor.green)
            line1.setCircleColor(UIColor.green)
            line1.lineWidth = 0.5
            line1.circleRadius = 0.6
            line1.fillColor = UIColor.green
            
            lineChartEntry2.append(ChartDataEntry(x: Double(i), y: Double(record_IMU_data[i][6]) ?? 0.0))
            let line2 = LineChartDataSet(entries: lineChartEntry2, label: "Second Dataset")
            data.addDataSet(line2)
            line2.setColor(UIColor.blue)
            line2.setCircleColor(UIColor.blue)
            line2.lineWidth = 0.5
            line2.circleRadius = 0.6
            line2.fillColor = UIColor.blue
            
        }
        
        self.Gyro_graph_view.data = data
        self.Gyro_graph_view.legend.enabled = false
        
    }
    
}

