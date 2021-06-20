//
//  LabelSortPresenter.swift
//  RadarChart
//
//  Created by M Aoshima on 2021/06/19.
//  Copyright © 2021 aoshima. All rights reserved.
//

import Foundation
import Charts

class LabelSortPresenter : LabelSortPresenterInput{
    
    private weak var view:LabelSortPresenterOutput!
    var groupData :ChartGroup!
    var radarChartData: RadarChartData{
        get{
            return MyChartUtil.getSampleChartData(color: groupData.color.toUIColor(), numberOfItems: groupData.labels.count)
        }
    }
    
    init(view:LabelSortPresenterOutput) {
        self.view = view
    }
    
    func viewDidLoad(passedData: ChartGroup) {
        groupData = passedData
        view.setChartDataSource()
    }
}

// Presenterが実装するプロトコル
// Viewから呼び出されるインターフェースを定義する
protocol LabelSortPresenterInput{
    var groupData:ChartGroup!{get}
    var radarChartData:RadarChartData{get}
    func viewDidLoad(passedData:ChartGroup)
}

// ViewControllerが実装するプロトコル
// Presenterから呼び出されるインターフェースを定義する
protocol LabelSortPresenterOutput:AnyObject {
    func setChartDataSource()
    func notifyChartDataChanged()
}
