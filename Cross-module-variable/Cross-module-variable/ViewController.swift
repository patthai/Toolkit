//
//  ViewController.swift
//  Cross-module-variable
//
//  Created by pat pataranutaporn on 1/9/19.
//  Copyright © 2019 pat pataranutaporn. All rights reserved.
//
struct globalvar{
    static var count = 0
}

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var count_1: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        globalvar.count = globalvar.count + 1
        count_1.text = String(globalvar.count)
    }


}

