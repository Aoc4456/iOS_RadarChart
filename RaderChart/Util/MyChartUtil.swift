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
    static func getSampleChartData(color:UIColor,numberOfItems:Int,value:Double = 60) -> RadarChartData{
        let radartChartDataSet = getSampleChartDataSet(color: color, numberOfItems: numberOfItems,value: value)
        return RadarChartData(dataSets: [radartChartDataSet])
    }
    
    static func getSampleChartDataSet(color:UIColor,numberOfItems:Int,value:Double = 60) -> RadarChartDataSet{
        var radarChartDataEntrySet:[RadarChartDataEntry] = []
        
        for _ in 0..<numberOfItems {
            radarChartDataEntrySet.append(RadarChartDataEntry(value: value))
        }
        
        let radarChartDataSet = RadarChartDataSet(entries: radarChartDataEntrySet)
        
        radarChartDataSet.lineWidth = 3
        radarChartDataSet.colors = [color]
        radarChartDataSet.fillColor = color
        radarChartDataSet.drawFilledEnabled = true
        radarChartDataSet.valueFormatter = SampleDataSetValueFormatter()
        return radarChartDataSet
    }
    
    static func getChartDataBasedOnInputValues(color:UIColor,values:[Double]) -> RadarChartData{
        let radartChartDataSet = getChartDataSetFromValue(color: color, values: values)
        return RadarChartData(dataSets: [radartChartDataSet])
    }
    
    static func getChartDataSetFromValue(color:UIColor,values:[Double]) -> RadarChartDataSet{
        var radarChartDataEntrySet:[RadarChartDataEntry] = []
        
        for i in 0..<values.count {
            radarChartDataEntrySet.append(RadarChartDataEntry(value: values[i]))
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
