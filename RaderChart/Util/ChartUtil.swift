//
//  ChartUtil.swift
//  RaderChart
//
//  Created by M Aoshima on 2021/04/24.
//  Copyright © 2021 aoshima. All rights reserved.
//

import Foundation
import UIKit
import Charts

class MyChartUtil{
    static func getSampleChartData(color:UIColor,numberOfItems:Int) -> RadarChartData{
        let raderChartDataSet = getSampleChartDataSet(color: color, numberOfItems: numberOfItems)
        return RadarChartData(dataSets: [raderChartDataSet])
    }
    
    static func getSampleChartDataSet(color:UIColor,numberOfItems:Int) -> RadarChartDataSet{
        var radarChartDataEntrySet:[RadarChartDataEntry] = []
        
        for _ in 0..<numberOfItems {
            radarChartDataEntrySet.append(RadarChartDataEntry(value: 60))
        }
        
        let raderChartDataSet = RadarChartDataSet(entries: radarChartDataEntrySet)
        
        raderChartDataSet.lineWidth = 3
        raderChartDataSet.colors = [color]
        raderChartDataSet.fillColor = color
        raderChartDataSet.drawFilledEnabled = true
        raderChartDataSet.valueFormatter = SampleDataSetValueFormatter()
        return raderChartDataSet
    }
}

// RaderChartDataSetにセットするFormatter
// 各項目の最終的な値を表示しないようにするため、""を返す
class SampleDataSetValueFormatter:IValueFormatter{
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return ""
    }
}
