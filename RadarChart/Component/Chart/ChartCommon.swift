//
//  ChartCommon.swift
//  RadarChart
//
//  Created by apple on 2021/05/13.
//  Copyright © 2021 aoshima. All rights reserved.
//

import Foundation
import Charts

class RowXAxisFormatter:IAxisValueFormatter{
    private var labels:[String] = ["項目1","項目2","項目3","項目4","項目5","項目6","項目7","項目8","項目9"]
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return labels[Int(value)]
    }
    
    func setLabel(labels:[String]){
        self.labels = labels
    }
}


class RowXAxisFormatterReturningEmpty:IAxisValueFormatter{
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return ""
    }
}

public enum LabelSizeType:Int{
    case None = 0   // グループ一覧
    case Small = 1  // チャート一覧_グリッド
    case Middle = 2 // チャート一覧_リスト
    case Large = 3  // グループ作成・チャート作成画面
}
