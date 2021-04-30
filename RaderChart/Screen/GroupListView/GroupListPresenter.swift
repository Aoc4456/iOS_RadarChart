//
//  GroupListViewPresenter.swift
//  RaderChart
//
//  Created by M Aoshima on 2021/04/30.
//  Copyright © 2021 aoshima. All rights reserved.
//

import Foundation

class GroupListPresenter:GroupListPresenterInput{
    
    private weak var view:GroupListPresenterOutput!
    
    var dataList: Array<ChartGroup> = []
    
    init(view:GroupListPresenterOutput) {
        self.view = view
    }
    
    func viewDidLoad() {
        // データベースからデータを取得
        dataList = DBProvider.sharedInstance.getGroupList()
        view.showGroupList()
    }
}


// Presenterが実装するプロトコル
// Viewから呼び出されるインターフェースを定義する
protocol GroupListPresenterInput {
    var dataList:Array<ChartGroup>{get}
    func viewDidLoad()
}

// ViewControllerが実装するプロトコル
// Presenterから呼び出されるインターフェースを定義する
protocol GroupListPresenterOutput:AnyObject {
    func showGroupList()
}
