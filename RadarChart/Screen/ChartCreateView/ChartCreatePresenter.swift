//
//  ChartCreatePresenter.swift
//  RadarChart
//
//  Created by M Aoshima on 2021/05/03.
//  Copyright © 2021 aoshima. All rights reserved.
//

import Foundation
import Charts
import RealmSwift

class ChartCreatePresenter:ChartCreatePresenterInput{
    
    private weak var view:ChartCreatePresenterOutput!
    private var groupData:ChartGroup!
    private var editChartObject:MyChartObject?
    
    var chartData: RadarChartData? = nil
    private var chartTitle = ""
    private var inputValues:[Double] = []
    private var note = ""
    
    init(view:ChartCreatePresenterOutput) {
        self.view = view
    }
    
    func viewDidLoad(groupData:ChartGroup,editChartObject:MyChartObject?) {
        self.groupData = groupData
        
        if(editChartObject != nil){
            self.editChartObject = editChartObject
            self.chartTitle = editChartObject!.title
            self.note = editChartObject!.note
            view.reflectEditData(myChartObject: editChartObject!)
        }
        
        createInputValues()
        
        view.setupMultiInputView(labels: Array(groupData.labels), values:inputValues, axisMaximum: Double(groupData.maximum))
        
        chartData = MyChartUtil.getChartDataBasedOnInputValues(color: groupData.color.toUIColor(), values: inputValues)
        
        view.InitializeChart()
    }
    
    // 入力の初期値は、最大値の60%とする
    private func createInputValues(){
        if(editChartObject == nil){
            let initialValue = Double(groupData.maximum) * 0.6
            for _ in 0..<groupData.labels.count{
                inputValues.append(initialValue)
            }
        }else{
            for i in 0..<groupData.labels.count{
                inputValues.append(editChartObject!.values[i])
            }
        }
    }
    
    func onChangeChartTitle(text: String) {
        chartTitle = text
    }
    
    func onChangeInputValue(index: Int, value: Double) {
        self.inputValues[index] = value
        self.chartData = MyChartUtil.getChartDataBasedOnInputValues(color: groupData.color.toUIColor(), values: inputValues)
        view.updateChart()
    }
    
    func onChangeNote(text: String) {
        self.note = text
    }
    
    func onTapSaveButton() {
        // 項目のバリデーション
        let errorMessage = validateData()
        if(errorMessage != ""){
            view.showValidateDialog(message: errorMessage)
            return
        }
        
        // データベースへの書き込み
        let saveChartObject = getChartObject()
        if(editChartObject == nil){
            DBProvider.sharedInstance.addChart(groupId: groupData.id, chartObject: saveChartObject)
        }else{
            DBProvider.sharedInstance.updateChart(oldChartObject: editChartObject!, newChartObject: saveChartObject)
        }
        
        // 画面を閉じる
        view.dismissScreen()
    }
    
    // 問題なければ空文字を、データに不正があればエラーメッセージを返す
    private func validateData() -> String{
        if(chartTitle == ""){
            return "タイトルが未入力です"
        }
        return ""
    }
    
    private func getChartObject() -> MyChartObject{
        var chartObject:MyChartObject? = nil
        chartObject = MyChartObject(value: ["title":chartTitle,"values":Array(inputValues),"note":note])
        return chartObject!
    }
    
    func deleteChart() {
        DBProvider.sharedInstance.deleteChart(id: editChartObject!.id)
        view.dismissScreen()
    }
}

// Presenterが実装するプロトコル
// Viewから呼び出されるインターフェースを定義する
protocol ChartCreatePresenterInput {
    var chartData:RadarChartData?{get}
    func viewDidLoad(groupData:ChartGroup,editChartObject:MyChartObject?)
    func onChangeInputValue(index:Int,value:Double)
    func onChangeChartTitle(text:String)
    func onChangeNote(text:String)
    func deleteChart()
    func onTapSaveButton()
}

// ViewControllerが実装するプロトコル
// Presenterから呼び出されるインターフェースを定義する
protocol ChartCreatePresenterOutput:AnyObject {
    func reflectEditData(myChartObject:MyChartObject)
    func setupMultiInputView(labels:[String],values:[Double],axisMaximum:Double)
    func InitializeChart()
    func updateChart()
    func showValidateDialog(message:String)
    func dismissScreen()
}
