import UIKit
import Charts
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var txtTextBox: UITextField!
    @IBOutlet weak var chtChart: LineChartView!
    
    let motionManager = CMMotionManager()
    var timer: Timer!
    var numbers : [[Double]] = []
    
    override func viewDidLoad()
    {
        motion_data()
        
    }
    func motion_data()
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
                
            }
        }
    }
    
    
    @IBAction func btnbutton(_ sender: Any) {
        var number1 = Double.random(in: 1.0 ..< 3.0)
        var number2 = Double.random(in: 4.0 ..< 6.0)
        var number3 = Double.random(in: 8.0 ..< 10.0)
        numbers.append([number1, number2, number3]) //here we add the data to the array.
        //print(numbers)
        updateGraph()
    }
    
    
    
    
    var duration = 40
    func updateGraph(){
        let data = LineChartData()
        
        var lineChartEntry0 = [ChartDataEntry]()
        var lineChartEntry1 = [ChartDataEntry]()
        var lineChartEntry2 = [ChartDataEntry]()
        
        var lower_bound = 0
        if (self.numbers.count > duration)
        {
            lower_bound = self.numbers.count - duration
        }
        
        for i in lower_bound..<numbers.count {
        
        lineChartEntry0.append(ChartDataEntry(x: Double(i), y: Double(numbers[i][0]) ?? 0.0))
        let line0 = LineChartDataSet(entries: lineChartEntry0, label: "First Dataset")
        data.addDataSet(line0)
        line0.setColor(UIColor.red)
        line0.setCircleColor(UIColor.red)
        line0.lineWidth = 1.0
        line0.circleRadius = 2.0
        line0.fillColor = UIColor.red
        
        lineChartEntry1.append(ChartDataEntry(x: Double(i), y: Double(numbers[i][1]) ?? 0.0))
        let line1 = LineChartDataSet(entries: lineChartEntry1, label: "Second Dataset")
        data.addDataSet(line1)
        line1.setColor(UIColor.green)
        line1.setCircleColor(UIColor.green)
        line1.lineWidth = 1.0
        line1.circleRadius = 2.0
        line1.fillColor = UIColor.green
            
        lineChartEntry2.append(ChartDataEntry(x: Double(i), y: Double(numbers[i][2]) ?? 0.0))
        let line2 = LineChartDataSet(entries: lineChartEntry2, label: "Second Dataset")
        data.addDataSet(line2)
        line2.setColor(UIColor.blue)
        line2.setCircleColor(UIColor.blue)
        line2.lineWidth = 1.0
        line2.circleRadius = 2.0
        line2.fillColor = UIColor.blue
            
        }
        
        self.chtChart.data = data
        self.chtChart.legend.enabled = false
        self.chtChart.leftAxis.axisMaximum = 1.5;
        self.chtChart.leftAxis.axisMinimum = -1.5;
        
    }
}
