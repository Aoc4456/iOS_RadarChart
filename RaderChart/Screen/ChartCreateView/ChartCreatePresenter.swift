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
    private var inputValues:[Int] = []
    
    init(view:ChartCreatePresenterOutput) {
        self.view = view
    }
    
    func viewDidLoad(groupData:ChartGroup) {
        self.groupData = groupData
        createInputValues()
        
        view.setupMultiInputView(labels: Array(groupData.labels), values:inputValues, axisMaximum: groupData.maximum)
        
        chartData = MyChartUtil.getSampleChartData(color: groupData.color.toUIColor(), numberOfItems: groupData.labels.count, value: Double(inputValues.first!))
        
        view.InitializeChart()
    }
    
    private func createInputValues(){
        let initialValue = Int(Double(groupData.maximum) * 0.6)
        for _ in 0..<groupData.labels.count{
            inputValues.append(initialValue)
        }
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
    func setupMultiInputView(labels:[String],values:[Int],axisMaximum:Int)
    func InitializeChart()
}
