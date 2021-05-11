//
//  ChartCreatePresenter.swift
//  RaderChart
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
    
    var chartData: RadarChartData? = nil
    private var chartTitle = ""
    private var inputValues:[Double] = []
    private var note = ""
    
    init(view:ChartCreatePresenterOutput) {
        self.view = view
    }
    
    func viewDidLoad(groupData:ChartGroup) {
        self.groupData = groupData
        createInputValues()
        
        view.setupMultiInputView(labels: Array(groupData.labels), values:inputValues, axisMaximum: Double(groupData.maximum))
        
        chartData = MyChartUtil.getSampleChartData(color: groupData.color.toUIColor(), numberOfItems: groupData.labels.count, value: inputValues.first!)
        
        view.InitializeChart()
    }
    
    // 入力の初期値は、最大値の60%とする
    private func createInputValues(){
        let initialValue = Double(groupData.maximum) * 0.6
        for _ in 0..<groupData.labels.count{
            inputValues.append(initialValue)
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
        // TODO このままだと、グループとの関連がないのでは..?
        // 外部キーをどう扱うのか確認
        print("保存データです\(saveChartObject.description)")
//        DBProvider.sharedInstance.addGroup(object: group)
        
        
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
}

// Presenterが実装するプロトコル
// Viewから呼び出されるインターフェースを定義する
protocol ChartCreatePresenterInput {
    var chartData:RadarChartData?{get}
    func viewDidLoad(groupData:ChartGroup)
    func onChangeInputValue(index:Int,value:Double)
    func onChangeChartTitle(text:String)
    func onChangeNote(text:String)
    func onTapSaveButton()
}

// ViewControllerが実装するプロトコル
// Presenterから呼び出されるインターフェースを定義する
protocol ChartCreatePresenterOutput:AnyObject {
    func setupMultiInputView(labels:[String],values:[Double],axisMaximum:Double)
    func InitializeChart()
    func updateChart()
    func showValidateDialog(message:String)
    func dismissScreen()
}
