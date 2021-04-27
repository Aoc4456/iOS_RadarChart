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
    var chartData: RadarChartData = MyChartUtil.getSampleChartData(color: UIColor.systemTeal, numberOfItems: 8)
    var sliderLabel = ["3","4","5","6","7","8"]
    var selectedColor: UIColor = UIColor.systemTeal
    var numberOfItems: Int = 5
    var axisMaximum: Int = 100
    var chartLabels: [String] = ["項目1","項目2","項目3","項目4","項目5","項目6","項目7","項目8","項目9"]
    
    init(view:GroupCreaterPresenterOutput) {
        self.view = view
    }
    
    func viewDidLoad() {
        chartData = MyChartUtil.getSampleChartData(color: selectedColor, numberOfItems: 8)
        view.setChartDataSource()
        // 最初に最大数のEntryで初期化しないと、Entryの数を大きくしたときクラッシュするため
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.onChangeChartData()
        }
    }
    
    func didSelectColor(color: UIColor) {
        selectedColor = color
        view.updateColor(color: selectedColor)
        onChangeChartData()
    }
    
    func didSliderValueChanged(index: Int) {
        numberOfItems = index + 3
        view.updateNumberOfItems(num: numberOfItems)
        onChangeChartData()
    }
    
    private func onChangeChartData(){
        chartData.removeDataSetByIndex(0)
        chartData.addDataSet(MyChartUtil.getSampleChartDataSet(color: selectedColor, numberOfItems: numberOfItems))
        view.notifyChartDataChanged()
    }
    
    func textFieldDidEndEditing(index: Int, text: String) {
        chartLabels[index] = text
        view.onUpdateChartLabel()
    }
    
    func onTapSaveButton() {
        onChangeChartData()
    }
}

// GroupCreatePresenterが実装するプロトコル
// Viewから呼び出されるインターフェースを定義する
protocol GroupCreatePresenterInput {
    var chartData:RadarChartData{get}
    var chartLabels:[String]{get}
    var sliderLabel:[String]{get}
    var selectedColor:UIColor{get set}
    var numberOfItems:Int{get set}
    var axisMaximum:Int{get set}
    func viewDidLoad()
    func didSelectColor(color:UIColor)
    func didSliderValueChanged(index:Int)
    func textFieldDidEndEditing(index:Int,text:String)
    func onTapSaveButton()
}

// GroupCreateViewControllerが実装するプロトコル
// Presenterから呼び出されるインターフェースを定義する
protocol GroupCreaterPresenterOutput:AnyObject {
    func updateNumberOfItems(num:Int)
    func updateColor(color:UIColor)
    func setChartDataSource()
    func notifyChartDataChanged()
    func onUpdateChartLabel()
}
