
//
//  SampleChartInCollectionCell.swift
//  RadarChart
//
//  Created by aoshima on 2021/05/12.
//  Copyright © 2021 aoshima. All rights reserved.
//

import Foundation
import Charts

class ChartForCollectionView:RadarChartView{
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        rotationEnabled = false
        legend.enabled = false
        highlightPerTapEnabled = false
        
        let xAxis = self.xAxis
        xAxis.labelFont = .systemFont(ofSize: 9.5,weight: .light)
        xAxis.valueFormatter = RowXAxisFormatter()
        
        let yAxis = self.yAxis
        //分割数
        yAxis.setLabelCount(6, force: true)
        yAxis.drawLabelsEnabled = false
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 100
        yAxis.axisRange = 100
        yAxis.spaceMax = 0
        yAxis.spaceMin = 0
        
//        let data = MyChartUtil.getSampleChartData(color: .blue, numberOfItems: 6)
//        self.data = data
    }
}
