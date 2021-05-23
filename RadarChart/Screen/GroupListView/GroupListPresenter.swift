//
//  GroupListViewPresenter.swift
//  RadarChart
//
//  Created by M Aoshima on 2021/04/30.
//  Copyright © 2021 aoshima. All rights reserved.
//

import Foundation
import UIKit

class GroupListPresenter:GroupListPresenterInput{
    
    private weak var view:GroupListPresenterOutput!
    
    var dataList: Array<ChartGroup> = []
    var iconImageMap: [Int:UIImage] = [:]
    
    init(view:GroupListPresenterOutput) {
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
        print("\(iconImageMap.count)個の画像を取得しました")
    }
}


// Presenterが実装するプロトコル
// Viewから呼び出されるインターフェースを定義する
protocol GroupListPresenterInput {
    var dataList:Array<ChartGroup>{get}
    var iconImageMap:[Int:UIImage]{get}
    func fetchDataFromDatabase()
}

// ViewControllerが実装するプロトコル
// Presenterから呼び出されるインターフェースを定義する
protocol GroupListPresenterOutput:AnyObject {
    func reloadTableView()
}
