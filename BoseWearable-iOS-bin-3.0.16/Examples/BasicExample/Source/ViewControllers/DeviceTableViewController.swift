//
//  DeviceTableViewController.swift
//  BasicExample
//
//  Created by Paul Calnan on 11/19/18.
//  Copyright © 2018 Bose Corporation. All rights reserved.
//

import BoseWearable
import UIKit
import Charts
import CoreData

class DeviceTableViewController: UITableViewController, UITextFieldDelegate {

    /// Set by the showing/presenting code.
    var session: WearableDeviceSession!

    /// Used to block the UI during connection.
    private var activityIndicator: ActivityIndicator?

    /// Used to block the UI when sensor service is suspended.
    private var suspensionOverlay: SuspensionOverlay?

    // We create the SensorDispatch without any reference to a session or a device.
    // We provide a queue on which the sensor data events are dispatched on.
    private let sensorDispatch = SensorDispatch(queue: .main)

    /// Retained for the lifetime of this object. When deallocated, deregisters
    /// this object as a WearableDeviceEvent listener.
    private var token: ListenerToken?

    // MARK: - IBOutlets

    @IBOutlet var pitchValue: UILabel!
    @IBOutlet var rollValue: UILabel!
    @IBOutlet var yawValue: UILabel!

    @IBOutlet var xValue: UILabel!
    @IBOutlet var yValue: UILabel!
    @IBOutlet var zValue: UILabel!
    
    @IBOutlet weak var IMU_graph_view: LineChartView!
    @IBOutlet weak var Gyro_graph_view: LineChartView!
    @IBOutlet weak var record_button: UIButton!
    @IBOutlet weak var record_duration: UITextField!
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var sampling_rate: UISegmentedControl!
    @IBOutlet weak var record_name: UITextField!
    @IBOutlet weak var record_class: UITextField!
    @IBOutlet weak var Save: UIButton!
    
    var record_status = false
    var sampling_rate_value = 0.05
    
    var record_time = 0
    var record_duration_value = 100
    
    var record_IMU_data : [[Double]] = []
    
    var time_var = ""
    var pitchValue_var = ""
    var rollValue_var = ""
    var yawValue_var = ""
    var xValue_var = ""
    var yValue_var = ""
    var zValue_var = ""
    
    

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // We set this object as the sensor dispatch handler in order to receive
        // sensor data.
        sensorDispatch.handler = self

        // Update the label font to use monospaced numbers.
        [pitchValue, rollValue, yawValue, xValue, yValue, zValue].forEach {
            $0?.useMonospacedNumbers()
            
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // If we are being pushed on to a navigation controller...
        if isMovingToParent {
            // Block this view controller's UI while the session is being opened
            activityIndicator = ActivityIndicator.add(to: navigationController?.view)

            // Register this view controller as the session delegate.
            session.delegate = self

            // Open the session.
            session.open()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // If we are being popped from a navigation controller...
        if isMovingFromParent {
            // Disable all sensors when dismissing. Since we retain the session
            // and will be deallocated after this, the session will be deallocated
            // and the communications channel closed.
            stopListeningForSensors()
        }
    }

    // Error handler function called at various points in this class.  If an error
    // occurred, show it in an alert. When the alert is dismissed, this function
    // dismisses this view controller by popping to the root view controller (we are
    // assumed to be on a navigation stack).
    private func dismiss(dueTo error: Error?, isClosing: Bool = false) {
        // Common dismiss handler passed to show()/showAlert().
        let popToRoot = { [weak self] in
            DispatchQueue.main.async {
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }

        // If the connection did close and it was not due to an error, just show
        // an appropriate message.
        if isClosing && error == nil {
            navigationController?.showAlert(title: "Disconnected", message: "The connection was closed", dismissHandler: popToRoot)
        }
        // Show an error alert.
        else {
            navigationController?.show(error, dismissHandler: popToRoot)
        }
    }

    private func listenForWearableDeviceEvents() {
        // Listen for incoming wearable device events. Retain the ListenerToken.
        // When the ListenerToken is deallocated, this object is automatically
        // removed as an event listener.
        token = session.device?.addEventListener(queue: .main) { [weak self] event in
            self?.wearableDeviceEvent(event)
        }
    }

    private func wearableDeviceEvent(_ event: WearableDeviceEvent) {
        switch event {
        case .didFailToWriteSensorConfiguration(let error):
            // Show an error if we were unable to set the sensor configuration.
            show(error)

        case .didSuspendWearableSensorService:
            // Block the UI when the sensor service is suspended.
            suspensionOverlay = SuspensionOverlay.add(to: navigationController?.view)

        case .didResumeWearableSensorService:
            // Unblock the UI when the sensor service is resumed.
            suspensionOverlay?.removeFromSuperview()

        default:
            break
        }
    }

    private func listenForSensors() {
        // Configure sensors at 50 Hz (a 20 ms sample period)
        session.device?.configureSensors { config in

            // Here, config is the current sensor config. We begin by turning off
            // all sensors, allowing us to start with a "clean slate."
            config.disableAll()

            // Enable the rotation and accelerometer sensors
            config.enable(sensor: .rotation, at: ._20ms)
            config.enable(sensor: .accelerometer, at: ._20ms)
        }
    }

    private func stopListeningForSensors() {
        // Disable all sensors.
        session.device?.configureSensors { config in
            config.disableAll()
        }
    }
    
    @IBAction func Print(_ sender: Any) {
        print (xValue_var,  yValue_var, zValue_var, pitchValue_var, rollValue_var, yawValue_var)
       
    }
    
    let nscontext = ((UIApplication.shared.delegate) as!
        AppDelegate).persistentContainer.viewContext
    
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
    
    @IBAction func INsert(_ sender: Any) {
        
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Record_event",into: nscontext)
        entity.setValue(record_name.text, forKey:"name") // email is a Your Entity Key
        entity.setValue(record_class.text, forKey: "activity")
        entity.setValue(String(record_duration_value), forKey: "duration")
        entity.setValue(String(sampling_rate_value), forKey: "sampling_rate")
        entity.setValue(String(record_IMU_data.description).replacingOccurrences(of: ",", with: " ", options: .literal, range: nil), forKey: "imu_data")
        
        do
        {
            try nscontext.save()
            
            
        }
        catch
        {
            
        }
        print("Record Inserted")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    
    
    @IBAction func rate_button(_ sender: Any) {
        switch sampling_rate.selectedSegmentIndex
        {
        case 0:
            sampling_rate_value = 0.05
        case 1:
            sampling_rate_value = 0.1
        case 2:
            sampling_rate_value = 0.5
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    func start_motion_data()
    {
        
        for i in 0..<self.record_duration_value {
            //print("Hello")
            
            
            print(time_var, xValue_var,  yValue_var, zValue_var, pitchValue_var, rollValue_var, yawValue_var)
            //self.record_IMU_data.append([Double(time_var) as! Double , Double(xValue_var) as! Double,  Double(yValue_var) as! Double, Double(zValue_var) as! Double, Double(pitchValue_var)as! Double , Double(rollValue_var) as! Double, Double(yawValue_var)as! Double])
            
            self.timer.text = "Progress : " + String(i) + "/" + String(self.record_duration_value)
            sleep(UInt32(sampling_rate_value))
        }
        
        self.stop_motion_data()
                
    }

    
    
    func stop_motion_data()
    {
    
        self.record_button.setTitle("Record", for: [])
        self.record_status = false
        print (record_IMU_data)
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


    


// MARK: - SensorDispatchHandler

// Note, we only have to implement the SensorDispatchHandler functions for the
// sensors we are interested in. These functions are called on the main queue
// as that is the queue provided to the SensorDispatch initializer.

extension DeviceTableViewController: SensorDispatchHandler {

    func receivedRotation(quaternion: Quaternion, accuracy: QuaternionAccuracy, timestamp: SensorTimestamp) {
        
        
        pitchValue.text = format(radians: quaternion.pitch)
        rollValue.text = format(radians: quaternion.roll)
        yawValue.text = format(radians: quaternion.yaw)
        
        time_var = String(timestamp)
        pitchValue_var = format(radians: quaternion.pitch)
        rollValue_var = format(radians: quaternion.roll)
        yawValue_var = format(radians: quaternion.yaw)
        
    }

    func receivedAccelerometer(vector: Vector, accuracy: VectorAccuracy, timestamp: SensorTimestamp) {
        xValue.text = format(decimal: vector.x)
        yValue.text = format(decimal: vector.y)
        zValue.text = format(decimal: vector.z)
        
        xValue_var = format(decimal: vector.x)
        yValue_var = format(decimal: vector.y)
        zValue_var = format(decimal: vector.z)
    }
}

// MARK: - WearableDeviceSessionDelegate

extension DeviceTableViewController: WearableDeviceSessionDelegate {
    func sessionDidOpen(_ session: WearableDeviceSession) {
        // The session opened successfully.

        // Set the title to the device's name.
        title = session.device?.name

        // Listen for wearable device events.
        listenForWearableDeviceEvents()

        // Listen for sensor data.
        listenForSensors()

        // Unblock this view controller's UI.
        activityIndicator?.removeFromSuperview()
        suspensionOverlay?.removeFromSuperview()
    }

    func session(_ session: WearableDeviceSession, didFailToOpenWithError error: Error?) {
        // The session failed to open due to an error.
        dismiss(dueTo: error)

        // Unblock this view controller's UI.
        activityIndicator?.removeFromSuperview()
        suspensionOverlay?.removeFromSuperview()
    }

    func session(_ session: WearableDeviceSession, didCloseWithError error: Error?) {
        // The session was closed, possibly due to an error.
        dismiss(dueTo: error, isClosing: true)

        // Unblock this view controller's UI.
        activityIndicator?.removeFromSuperview()
        suspensionOverlay?.removeFromSuperview()
    }
}
