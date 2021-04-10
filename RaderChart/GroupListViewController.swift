//
//  ViewController.swift
//  RaderChart
//
//  Created by aoshima on 2021/04/09.
//  Copyright © 2021 aoshima. All rights reserved.
//

import UIKit
import Charts

class GroupListViewController: UIViewController {

    @IBOutlet weak var radarChart: RadarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // 1
        let greenDataSet = RadarChartDataSet(
            entries: [
                RadarChartDataEntry(value: 210),
                RadarChartDataEntry(value: 60.0),
                RadarChartDataEntry(value: 150.0),
                RadarChartDataEntry(value: 150.0),
                RadarChartDataEntry(value: 160.0),
                RadarChartDataEntry(value: 150.0),
                RadarChartDataEntry(value: 110.0),
                RadarChartDataEntry(value: 190.0),
                RadarChartDataEntry(value: 200.0)
            ]
        )
        let redDataSet = RadarChartDataSet(
            entries: [
                RadarChartDataEntry(value: 120.0),
                RadarChartDataEntry(value: 160.0),
                RadarChartDataEntry(value: 110.0),
                RadarChartDataEntry(value: 110.0),
                RadarChartDataEntry(value: 210.0),
                RadarChartDataEntry(value: 120.0),
                RadarChartDataEntry(value: 210.0),
                RadarChartDataEntry(value: 100.0),
                RadarChartDataEntry(value: 210.0)
            ]
        )

        // 2
        let data = RadarChartData(dataSets: [greenDataSet, redDataSet])

        // 3
        radarChart.data = data
    }


}

