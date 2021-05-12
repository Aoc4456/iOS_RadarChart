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
    private var groupData:ChartGroup!
    
    init(view:ChartCollectionPresenterOutput) {
        self.view = view
    }
    
    func viewDidLoad(groupData:ChartGroup) {
        self.groupData = groupData
    }
    
    func fetchDataFromDatabase() {
        // viewDidLoad で　得た idを使ってもう一度最新のグループデータを取得しに行く
    }
    
}

// Presenterが実装するプロトコル
// Viewから呼び出されるインターフェースを定義する
protocol ChartCollectionPresenterInput {
    func viewDidLoad(groupData:ChartGroup)
    func fetchDataFromDatabase()
}

// ViewControllerが実装するプロトコル
// Presenterから呼び出されるインターフェースを定義する
protocol ChartCollectionPresenterOutput:AnyObject {
    func notifyDataSetChanged()
}
