//
//  GroupCreateSampleChart.swift
//  RadarChart
//
//  Created by M Aoshima on 2021/04/22.
//  Copyright © 2021 aoshima. All rights reserved.
//

import Foundation
import Charts

// 項目名の並び替え画面で使用する
class ChartForItemSortScreen:RadarChartView{
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        fixedLabelSize = LabelSizeType.Small.rawValue
        
        rotationEnabled = false
        legend.enabled = false
        highlightPerTapEnabled = false
        
        let xAxis = self.xAxis
        xAxis.labelFont = .systemFont(ofSize: 14,weight: .regular)
        xAxis.valueFormatter = RowXAxisFormatter()
        
        let yAxis = self.yAxis
        
        yAxis.setLabelCount(4, force: true) // 分割数
        yAxis.drawLabelsEnabled = false
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 90
        yAxis.axisRange = 90
        yAxis.spaceMax = 0
        yAxis.spaceMin = 0
    }
}
