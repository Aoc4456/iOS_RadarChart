//
//  ChartCreatePresenter.swift
//  RaderChart
//
//  Created by M Aoshima on 2021/05/03.
//  Copyright © 2021 aoshima. All rights reserved.
//

import Foundation
import Charts

class ChartCreatePresenter:ChartCreatePresenterInput{
    
    private weak var view:ChartCreatePresenterOutput!
    private var groupData:ChartGroup!
    
    var chartData: RadarChartData? = nil
    private var chartTitle = ""
    
    init(view:ChartCreatePresenterOutput) {
        self.view = view
    }
    
    func viewDidLoad(groupData:ChartGroup) {
        self.groupData = groupData
        
        view.setupMultiInputView(labels: Array(groupData.labels), axisMaximum: groupData.maximum)
        
        // MARK: チャートの初期データをセットする (valueを、MultiInputViewと同期する)
        chartData = MyChartUtil.getSampleChartData(color: groupData.color.toUIColor(), numberOfItems: groupData.labels.count, value: round(Double(groupData.maximum) * 0.6))
        
        view.InitializeChart()
    }
}

// Presenterが実装するプロトコル
// Viewから呼び出されるインターフェースを定義する
protocol ChartCreatePresenterInput {
    var chartData:RadarChartData?{get}
    func viewDidLoad(groupData:ChartGroup)
}

// ViewControllerが実装するプロトコル
// Presenterから呼び出されるインターフェースを定義する
protocol ChartCreatePresenterOutput:AnyObject {
    func setupMultiInputView(labels:[String],axisMaximum:Int)
    func InitializeChart()
}
