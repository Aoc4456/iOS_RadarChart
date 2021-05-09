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
    static func getGroupChartData(color:UIColor,numberOfItems:Int) -> RadarChartData{
        let radartChartDataSet = getGroupChartDataSet(color: color, numberOfItems: numberOfItems)
        return RadarChartData(dataSets: [radartChartDataSet])
    }
    
    static func getGroupChartDataSet(color:UIColor,numberOfItems:Int) -> RadarChartDataSet{
        var radarChartDataEntrySet:[RadarChartDataEntry] = []
        
        for _ in 0..<numberOfItems {
            radarChartDataEntrySet.append(RadarChartDataEntry(value: 60))
        }
        
        let radarChartDataSet = RadarChartDataSet(entries: radarChartDataEntrySet)
        
        radarChartDataSet.lineWidth = 3
        radarChartDataSet.colors = [color]
        radarChartDataSet.fillColor = color
        radarChartDataSet.drawFilledEnabled = true
        radarChartDataSet.valueFormatter = SampleDataSetValueFormatter()
        return radarChartDataSet
    }
    
    
}

// RadarChartDataSetにセットするFormatter
// 各項目の最終的な値を表示しないようにするため、""を返す
class SampleDataSetValueFormatter:IValueFormatter{
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return ""
    }
}
