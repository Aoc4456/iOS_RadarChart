//
//  ChartCollectionPresenter.swift
//  RadarChart
//
//  Created by M Aoshima on 2021/05/02.
//  Copyright © 2021 aoshima. All rights reserved.
//

import Foundation
import UIKit

class ChartCollectionPresenter:ChartCollectionPresenterInput{
    
    private weak var view:ChartCollectionPresenterOutput!
    var groupData:ChartGroup!
    var chartList:[MyChartObject] = [MyChartObject]()
    
    init(view:ChartCollectionPresenterOutput) {
        self.view = view
    }
    
    func viewDidLoad(groupData:ChartGroup) {
        self.groupData = groupData
        view.setButtonLabel(orderItemLabel: getSortItemLabel(), ascDescLabel: getAscDescLabel())
    }
    
    func fetchDataFromDatabase() {
        self.groupData = DBProvider.sharedInstance.getGroup(id: groupData.id)
        self.chartList = DBProvider.sharedInstance.getSortedCharts(group: groupData)
        view.notifyDataSetChanged()
    }
    
    func getTappedChartObject(index: Int) -> MyChartObject {
        return chartList[index]
    }
    
    func onTapSortItemButton() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: {
            action in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        let totalAction = UIAlertAction(title: "合計値", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            self.onTapActionSheetItem(index: -3)
        })
        alert.addAction(totalAction)
        
        for i in 0..<groupData.labels.count{
            let action = UIAlertAction(title: groupData.labels[i], style: .default, handler:{
                (action: UIAlertAction!) -> Void in
                self.onTapActionSheetItem(index: i)
            })
            alert.addAction(action)
        }
        
        let createdDateAction = UIAlertAction(title: "作成日", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            self.onTapActionSheetItem(index: -1)
        })
        let updatedDateAction = UIAlertAction(title: "更新日", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            self.onTapActionSheetItem(index: -2)
        })
        alert.addAction(createdDateAction)
        alert.addAction(updatedDateAction)
        view.showActionSheet(alert: alert)
    }
    
    func onTapActionSheetItem(index:Int){
        if(groupData.sortedIndex == index){
            return
        }
        DBProvider.sharedInstance.changeSortIndex(group: groupData, index: index)
        fetchDataFromDatabase()
        view.setButtonLabel(orderItemLabel: getSortItemLabel(), ascDescLabel: getAscDescLabel())
    }
    
    func onTapAscDescButton() {
        DBProvider.sharedInstance.changeAscDesc(chartGroup: groupData)
        fetchDataFromDatabase()
        view.setButtonLabel(orderItemLabel: getSortItemLabel(), ascDescLabel: getAscDescLabel())
    }
    
    private func getSortItemLabel() -> String{
        switch groupData.sortedIndex {
        case -3:
            return "合計値"
        case -2:
            return "更新日"
        case -1:
            return "作成日"
        default:
            return groupData.labels[groupData.sortedIndex]
        }
    }
    
    private func getAscDescLabel() -> String{
        switch groupData.orderBy {
        case "ASC":
            return "昇順"
        case "DESC":
            return "降順"
        default:
            return ""
        }
    }
}

// Presenterが実装するプロトコル
// Viewから呼び出されるインターフェースを定義する
protocol ChartCollectionPresenterInput {
    var groupData:ChartGroup!{get}
    var chartList:[MyChartObject]{get}
    func onTapSortItemButton()
    func onTapAscDescButton()
    func viewDidLoad(groupData:ChartGroup)
    func fetchDataFromDatabase()
    func getTappedChartObject(index:Int) -> MyChartObject
}

// ViewControllerが実装するプロトコル
// Presenterから呼び出されるインターフェースを定義する
protocol ChartCollectionPresenterOutput:AnyObject {
    func setButtonLabel(orderItemLabel:String,ascDescLabel:String)
    func notifyDataSetChanged()
    func showActionSheet(alert:UIAlertController)
}
