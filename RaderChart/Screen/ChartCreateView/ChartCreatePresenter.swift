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
    private var inputValues:[Double] = []
    
    init(view:ChartCreatePresenterOutput) {
        self.view = view
    }
    
    func viewDidLoad(groupData:ChartGroup) {
        self.groupData = groupData
        createInputValues()
        
        view.setupMultiInputView(labels: Array(groupData.labels), values:inputValues, axisMaximum: Double(groupData.maximum))
        
        chartData = MyChartUtil.getSampleChartData(color: groupData.color.toUIColor(), numberOfItems: groupData.labels.count, value: Double(inputValues.first!))
        
        view.InitializeChart()
    }
    
    // 入力の初期値は、最大値の60%とする
    private func createInputValues(){
        let initialValue = Double(groupData.maximum) * 0.6
        for _ in 0..<groupData.labels.count{
            inputValues.append(initialValue)
        }
    }
    
    func onChangeInputValue(index: Int, value: Double) {
        self.inputValues[index] = value
    }
}

// Presenterが実装するプロトコル
// Viewから呼び出されるインターフェースを定義する
protocol ChartCreatePresenterInput {
    var chartData:RadarChartData?{get}
    func viewDidLoad(groupData:ChartGroup)
    func onChangeInputValue(index:Int,value:Double)
}

// ViewControllerが実装するプロトコル
// Presenterから呼び出されるインターフェースを定義する
protocol ChartCreatePresenterOutput:AnyObject {
    func setupMultiInputView(labels:[String],values:[Double],axisMaximum:Double)
    func InitializeChart()
}
