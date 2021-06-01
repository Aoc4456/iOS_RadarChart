//
//  GroupSortPresenter.swift
//  RadarChart
//
//  Created by M Aoshima on 2021/06/01.
//  Copyright © 2021 aoshima. All rights reserved.
//

import Foundation
import UIKit

class GroupSortPresenter:GroupSortPresenterInput{
    
    private weak var view:GroupSortPresenterOutput!
    
    var dataList: Array<ChartGroup> = []
    var iconImageMap: [Int:UIImage] = [:]
    
    init(view:GroupSortPresenterOutput) {
        self.view = view
    }
    
    func fetchDataFromDatabase() {
        // データベースからデータを取得
        dataList = DBProvider.sharedInstance.getGroupList()
        loadIconImages()
        view.reloadTableView()
    }
    
    private func loadIconImages(){
        iconImageMap.removeAll()
        for i in 0..<dataList.count{
            let fileName = dataList[i].iconFileName
            if(fileName != ""){
                let image = DBProvider.sharedInstance.loadImage(filename: fileName)
                iconImageMap[i] = image
            }
        }
    }
    
}


// Presenterが実装するプロトコル
// Viewから呼び出されるインターフェースを定義する
protocol GroupSortPresenterInput{
    var dataList:Array<ChartGroup>{get}
    var iconImageMap:[Int:UIImage]{get}
    func fetchDataFromDatabase()
}


// ViewControllerが実装するプロトコル
// Presenterから呼び出されるインターフェースを定義する
protocol GroupSortPresenterOutput:AnyObject {
    func reloadTableView()
}
