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
    var isEnableSortButton:Bool{
        get{
            return dataList.count >= 2
        }
    }
    
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
    }
    
    func makeContextMenu(index: Int) -> UIMenu {
        let data = dataList[index]
        let groupEdit = UIAction(title: "グループ編集", image: UIImage(systemName: "pencil")) { action in
            self.view.goToGroupEditViewController(chartGroup: data)
        }
        let sort = UIAction(title: "項目名の並び替え", image: UIImage(systemName: "arrow.up.arrow.down.square")) { action in
            self.view.goToLabelSortViewController(chartGroup: data)
        }
        return UIMenu(title: "編集", children: [groupEdit, sort])
    }
}


// Presenterが実装するプロトコル
// Viewから呼び出されるインターフェースを定義する
protocol GroupListPresenterInput {
    var dataList:Array<ChartGroup>{get}
    var iconImageMap:[Int:UIImage]{get}
    var isEnableSortButton:Bool{get}
    func fetchDataFromDatabase()
    func makeContextMenu(index:Int) -> UIMenu
}

// ViewControllerが実装するプロトコル
// Presenterから呼び出されるインターフェースを定義する
protocol GroupListPresenterOutput:AnyObject {
    func reloadTableView()
    func goToGroupEditViewController(chartGroup:ChartGroup)
    func goToLabelSortViewController(chartGroup:ChartGroup)
}
