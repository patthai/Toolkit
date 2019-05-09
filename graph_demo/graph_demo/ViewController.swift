//
//  ViewController.swift
//  graph_demo
//
//  Created by pat pataranutaporn on 5/8/19.
//  Copyright © 2019 pat pataranutaporn. All rights reserved.
//

import UIKit
import SwiftCharts

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        let chartConfig = ChartConfigXY(
            xAxisConfig: ChartAxisConfig(from: 2, to: 14, by: 2),
            yAxisConfig: ChartAxisConfig(from: 0, to: 14, by: 2)
        )
        
        let frame = CGRect(x: 0, y: 70, width: 300, height: 500)
        
        let chart = LineChart(
            frame: frame,
            chartConfig: chartConfig,
            xTitle: "X axis",
            yTitle: "Y axis",
            lines: [
                (chartPoints: [(2.0, 10.6), (4.2, 5.1), (7.3, 3.0), (8.1, 5.5), (14.0, 8.0)], color: UIColor.red),
                (chartPoints: [(2.0, 2.6), (4.2, 4.1), (7.3, 1.0), (8.1, 11.5), (14.0, 3.0)], color: UIColor.blue)
            ]
        )
        
        self.view.addSubview(chart.view)

    }
    


}

