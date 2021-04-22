//
//  GroupCreatePresenter.swift
//  RaderChart
//
//  Created by M Aoshima on 2021/04/22.
//  Copyright © 2021 aoshima. All rights reserved.
//

import Foundation
import UIKit
import Charts

class GroupCreatePresenter:GroupCreatePresenterInput{
    
    private weak var view:GroupCreaterPresenterOutput!
    var chartData: RadarChartDataSet? = nil
    var sliderLabel = ["3","4","5","6","7","8"]
    var selectedColor: UIColor = UIColor.systemTeal
    var numberOfItems: Int = 0
    
    init(view:GroupCreaterPresenterOutput) {
        self.view = view
        chartData = RadarChartDataSet(
            entries: [
                RadarChartDataEntry(value: 210),
                RadarChartDataEntry(value: 60.0),
                RadarChartDataEntry(value: 150.0),
                RadarChartDataEntry(value: 150.0),
                RadarChartDataEntry(value: 160.0),
                RadarChartDataEntry(value: 150.0),
                RadarChartDataEntry(value: 110.0),
                RadarChartDataEntry(value: 190.0),
                RadarChartDataEntry(value: 200.0)
            ]
        )
    }
    
    func viewDidLoad() {
        view.updateSampleChart()
    }
    
    func didSelectColor(color: UIColor) {
        selectedColor = color
        view.updateColor(color: selectedColor)
    }
    
    func didSliderValueChanged(index: Int) {
        numberOfItems = index + 3
        view.updateNumberOfItemsLabel(num: numberOfItems)
    }
}

// GroupCreatePresenterが実装するプロトコル
// Viewから呼び出されるインターフェースを定義する
protocol GroupCreatePresenterInput {
    var chartData:RadarChartDataSet?{get}
    var sliderLabel:[String]{get}
    var selectedColor:UIColor{get set}
    var numberOfItems:Int{get set}
    func viewDidLoad()
    func didSelectColor(color:UIColor)
    func didSliderValueChanged(index:Int)
}

// GroupCreateViewControllerが実装するプロトコル
// Presenterから呼び出されるインターフェースを定義する
protocol GroupCreaterPresenterOutput:AnyObject {
    func updateNumberOfItemsLabel(num:Int)
    func updateColor(color:UIColor)
    func updateSampleChart()
}
