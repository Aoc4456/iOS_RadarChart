//
//  GroupCreateSampleChart.swift
//  RadarChart
//
//  Created by M Aoshima on 2021/04/22.
//  Copyright © 2021 aoshima. All rights reserved.
//

import Foundation
import Charts

// グループ作成画面・チャート作成画面で使用する
class SampleChartInCreateScreen:RadarChartView{
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        rotationEnabled = false
        legend.enabled = false
        highlightPerTapEnabled = false
        
        let xAxis = self.xAxis
        xAxis.labelFont = .systemFont(ofSize: 15,weight: .bold)
        xAxis.valueFormatter = RowXAxisFormatter()
        
        let yAxis = self.yAxis
        
        yAxis.setLabelCount(6, force: true) // 分割数
        yAxis.drawLabelsEnabled = false
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 100
        yAxis.axisRange = 100
        yAxis.spaceMax = 0
        yAxis.spaceMin = 0
    }
}

class RowXAxisFormatter:IAxisValueFormatter{
    private var labels:[String] = ["項目1","項目2","項目3","項目4","項目5","項目6","項目7","項目8","項目9"]
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return labels[Int(value)]
    }
    
    func setLabel(labels:[String]){
        self.labels = labels
    }
}
