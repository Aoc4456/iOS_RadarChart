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
    var chartColor:UIColor!
    private var chartTitle = ""
    private var inputValues:[Double] = []
    private var note = ""
    
    var chartLabel: [String]{
        get{
            var temporalyLabels = Array(groupData.labels)
            
            for i in 0..<temporalyLabels.count{
                let label = temporalyLabels[i]
                let inputValue = Int(inputValues[i])
                let withValueLabel = "\(label)\n\(getSpace(text: label,value: inputValue.description))\(inputValue)"
                temporalyLabels[i] = withValueLabel
            }
            
            temporalyLabels.append("") // これがないとクラッシュする (ライブラリのバグ)
            return temporalyLabels
        }
    }
    
    private var totalAverageText:String{
        get{
            let sum = inputValues.reduce(0, +)
            var average = sum / Double(inputValues.count)
            average = round(average*10)/10 // 小数第2位で四捨五入
            return "合計：\(Int(sum))　平均：\(average)"
        }
    }
    
    init(view:ChartCreatePresenterOutput) {
        self.view = view
    }
    
    func viewDidLoad(groupData:ChartGroup,editChartObject:MyChartObject?) {
        self.groupData = groupData
        
        if(editChartObject == nil){
            self.chartColor = groupData.color.toUIColor()
        }else{
            self.editChartObject = editChartObject
            self.chartTitle = editChartObject!.title
            self.note = editChartObject!.note
            self.chartColor = editChartObject!.color.toUIColor()
            view.reflectEditData(myChartObject: editChartObject!)
        }
        
        createInputValues()
        view.updateTotalAverageLabel(text: self.totalAverageText)
        
        view.setButtonColor()
        
        view.setupMultiInputView(labels: Array(groupData.labels), values:inputValues, axisMaximum: Double(groupData.maximum))
        
        chartData = MyChartUtil.getChartDataBasedOnInputValues(color: chartColor, values: inputValues)
        
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
    
    func didSelectColor(color: UIColor) {
        self.chartColor = color
        view.setButtonColor()
        self.chartData = MyChartUtil.getChartDataBasedOnInputValues(color: chartColor, values: inputValues)
        view.updateChart()
    }
    
    func onChangeInputValue(index: Int, value: Double) {
        self.inputValues[index] = value
        self.chartData = MyChartUtil.getChartDataBasedOnInputValues(color: chartColor, values: inputValues)
        view.updateChart()
        view.updateTotalAverageLabel(text: self.totalAverageText)
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
        chartObject = MyChartObject(value: ["title":chartTitle,"values":Array(inputValues),"note":note,"color":chartColor.toString()])
        return chartObject!
    }
    
    func deleteChart() {
        DBProvider.sharedInstance.deleteChart(id: editChartObject!.id)
        view.dismissScreen()
    }
    
    // 上段と下段のテキストの幅の差の分のスペースを返す (無理矢理２行目を中央よせに見せる)
    private func getSpace(text:String,value:String) -> String{
        let font = UIFont.systemFont(ofSize: 15.0)
        
        let labelWidth = text.size(withAttributes: [NSAttributedString.Key.font : font]).width
        let valueWidth = value.size(withAttributes: [NSAttributedString.Key.font : font]).width
        let spaceWidth = " ".size(withAttributes: [NSAttributedString.Key.font : font]).width
        
        if(valueWidth < labelWidth){
            let requireSpace = labelWidth - valueWidth
            let requireStartSpace = requireSpace / 2
            let spaceCount = requireStartSpace / spaceWidth
            
            var text = ""
            for _ in 0..<Int(spaceCount){
                text.append(" ")
            }
            return text
        }
        
        return ""
    }
}

// Presenterが実装するプロトコル
// Viewから呼び出されるインターフェースを定義する
protocol ChartCreatePresenterInput {
    var chartData:RadarChartData?{get}
    var chartLabel:[String]{get}
    var chartColor:UIColor!{get}
    func viewDidLoad(groupData:ChartGroup,editChartObject:MyChartObject?)
    func didSelectColor(color:UIColor)
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
    func setButtonColor()
    func InitializeChart()
    func updateChart()
    func updateTotalAverageLabel(text:String)
    func showValidateDialog(message:String)
    func dismissScreen()
}
