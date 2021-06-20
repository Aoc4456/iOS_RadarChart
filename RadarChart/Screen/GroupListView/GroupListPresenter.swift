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
    
    func onCellLongPressed(index: Int, rect: CGRect) {
        let data = dataList[index]
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "グループ編集", style: .default, handler: {
            action in
            self.view.goToGroupEditViewController(chartGroup: data)
        }))
        alert.addAction(UIAlertAction(title: "項目名の並び替え", style: .default, handler: {
            action in
            self.view.goToLabelSortViewController(chartGroup: data)
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: {
            action in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        view.showCellLongPressedActionSheet(alert: alert,rect:rect)
    }
}


// Presenterが実装するプロトコル
// Viewから呼び出されるインターフェースを定義する
protocol GroupListPresenterInput {
    var dataList:Array<ChartGroup>{get}
    var iconImageMap:[Int:UIImage]{get}
    var isEnableSortButton:Bool{get}
    func fetchDataFromDatabase()
    func onCellLongPressed(index : Int, rect : CGRect)
}

// ViewControllerが実装するプロトコル
// Presenterから呼び出されるインターフェースを定義する
protocol GroupListPresenterOutput:AnyObject {
    func reloadTableView()
    func showCellLongPressedActionSheet(alert:UIAlertController,rect:CGRect)
    func goToGroupEditViewController(chartGroup:ChartGroup)
    func goToLabelSortViewController(chartGroup:ChartGroup)
}
