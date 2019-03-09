import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    let motionManager = CMMotionManager()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
            motionManager.deviceMotionUpdateInterval = 0.01
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
    
}
