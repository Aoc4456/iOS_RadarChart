//
//  ChartCollectionPresenter.swift
//  RadarChart
//
//  Created by M Aoshima on 2021/05/02.
//  Copyright © 2021 aoshima. All rights reserved.
//

import Foundation

class ChartCollectionPresenter:ChartCollectionPresenterInput{
    
    private weak var view:ChartCollectionPresenterOutput!
    var groupData:ChartGroup!
    
    init(view:ChartCollectionPresenterOutput) {
        self.view = view
    }
    
    func viewDidLoad(groupData:ChartGroup) {
        self.groupData = groupData
    }
    
    func fetchDataFromDatabase() {
        self.groupData = DBProvider.sharedInstance.getGroup(id: groupData.id)
        view.notifyDataSetChanged()
    }
    
}

// Presenterが実装するプロトコル
// Viewから呼び出されるインターフェースを定義する
protocol ChartCollectionPresenterInput {
    var groupData:ChartGroup!{get}
    func viewDidLoad(groupData:ChartGroup)
    func fetchDataFromDatabase()
}

// ViewControllerが実装するプロトコル
// Presenterから呼び出されるインターフェースを定義する
protocol ChartCollectionPresenterOutput:AnyObject {
    func notifyDataSetChanged()
}
