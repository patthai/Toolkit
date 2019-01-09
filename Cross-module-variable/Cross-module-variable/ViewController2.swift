//
//  ViewController2.swift
//  Cross-module-variable
//
//  Created by pat pataranutaporn on 1/9/19.
//  Copyright © 2019 pat pataranutaporn. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    @IBOutlet weak var count_2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        globalvar.count = globalvar.count + 1
        count_2.text = String(globalvar.count)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
