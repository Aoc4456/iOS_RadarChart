//
//  GroupCreateSampleChart.swift
//  RaderChart
//
//  Created by M Aoshima on 2021/04/22.
//  Copyright © 2021 aoshima. All rights reserved.
//

import Foundation
import Charts

class GroupCreateSampleChart:RadarChartView{
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
//        xAxis.xOffset = 20
//        xAxis.yOffset = 20
        xAxis.labelFont = .systemFont(ofSize: 15,weight: .bold)
        
        let yAxis = self.yAxis
        //分割数
        yAxis.labelCount = 5
        yAxis.drawLabelsEnabled = false
    }
}
