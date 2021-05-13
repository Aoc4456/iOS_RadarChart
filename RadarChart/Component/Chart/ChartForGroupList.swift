//
//  SampleChartInList.swift
//  RadarChart
//
//  Created by M Aoshima on 2021/04/30.
//  Copyright © 2021 aoshima. All rights reserved.
//

import Foundation
import Charts

class ChartForGroupList:RadarChartView{
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    /**
     * 2.’required’ initializer ‘init(coder:)’ must be provided by subclass of ~
     * というエラーが出た場合
     * swiftの場合requiredメソッドも実装する必要があります
     **/
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        rotationEnabled = false
        legend.enabled = false
        highlightPerTapEnabled = false
        
        let xAxis = self.xAxis
        xAxis.valueFormatter = RowXAxisFormatterReturningEmpty()
        
        let yAxis = self.yAxis
        //分割数
        yAxis.setLabelCount(4, force: true)
        yAxis.drawLabelsEnabled = false
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 90
        yAxis.axisRange = 90
        yAxis.spaceMax = 0
        yAxis.spaceMin = 0
    }
}
