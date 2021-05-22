//
//  GroupCreatePresenter.swift
//  RadarChart
//
//  Created by M Aoshima on 2021/04/22.
//  Copyright © 2021 aoshima. All rights reserved.
//

import Foundation
import UIKit
import Charts
import RealmSwift

class GroupCreatePresenter:GroupCreatePresenterInput{
    
    private weak var view:GroupCreaterPresenterOutput!
    var chartData: RadarChartData = MyChartUtil.getSampleChartData(color: UIColor.systemTeal, numberOfItems: 8)
    var title = ""
    var sliderLabel = ["3","4","5","6","7","8"]
    var selectedColor: UIColor = UIColor.systemTeal
    var numberOfItems: Int = 5
    var axisMaximum: Double = 100
    var chartLabels: [String] = ["項目1","項目2","項目3","項目4","項目5","項目6","項目7","項目8","項目9"]
    
    private var iconImage:UIImage?
    private var isIconChange = false
    var imagePath:String = ""
    
    private var passedData:ChartGroup?
    
    init(view:GroupCreaterPresenterOutput) {
        self.view = view
    }
    
    func viewDidLoad(passedData:ChartGroup?) {
        chartData = MyChartUtil.getSampleChartData(color: selectedColor, numberOfItems: numberOfItems)
        view.setChartDataSource()
        
        if(passedData != nil){
            self.passedData = passedData!
            self.title = passedData!.title
            self.selectedColor = passedData!.color.toUIColor()
            self.numberOfItems = Int(passedData!.labels.count)
            self.axisMaximum = passedData!.maximum
            self.imagePath = passedData!.imagePath
            for i in 0..<passedData!.labels.count{
                self.chartLabels[i] = Array(passedData!.labels)[i]
            }
            if(imagePath != ""){
                iconImage = UIImage(contentsOfFile: imagePath)
                print(iconImage?.description)
            }
            self.view.reflectThePassedData(iconImage: iconImage)
        }
        self.onChangeChartData()
    }
    
    func didSelectColor(color: UIColor) {
        selectedColor = color
        view.updateColor(color: selectedColor)
        onChangeChartData()
    }
    
    func onTapIconButton() {
        let alert = UIAlertController(title: "グループのアイコンを設定", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: {
            action in
            alert.dismiss(animated: true, completion: nil)
        }))
        let selectImageAction = UIAlertAction(title: "画像を選択", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            self.view.showImagePicker(picker: picker)
        })
        alert.addAction(selectImageAction)
        
        if(self.iconImage != nil){
            let deleteImageAction = UIAlertAction(title: "削除", style: .destructive, handler:{
                (action: UIAlertAction!) -> Void in
                self.iconImage = nil
                self.view.deleteImage()
            })
            alert.addAction(deleteImageAction)
        }
        self.view.showIconActionSheet(alert: alert)
    }
    
    func didCropToImage(image: UIImage) {
        iconImage = image
        isIconChange = true
    }
    
    func didSliderValueChanged(index: Int) {
        numberOfItems = index + 3
        view.updateNumberOfItems(num: numberOfItems,chartLabels: chartLabels)
        onChangeChartData()
    }
    
    private func onChangeChartData(){
        chartData.removeDataSetByIndex(0)
        chartData.addDataSet(MyChartUtil.getSampleChartDataSet(color: selectedColor, numberOfItems: numberOfItems))
        view.notifyChartDataChanged()
    }
    
    func titleTextFieldDidEndEditing(text: String) {
        title = text
    }
    
    func labelTextFieldDidEndEditing(index: Int, text: String) {
        chartLabels[index] = text
        view.onUpdateChartLabel()
    }
    
    func axisMaximumTextFieldDidEndEditing(text: String) {
        axisMaximum = Double(text) ?? 100
    }
    
    func onTapSaveButton() {
        // 項目のバリデーション
        let errorMessage = validateData()
        if(errorMessage != ""){
            view.showValidateDialog(text: errorMessage)
            return
        }
        
        // データベースへの書き込み
        // TODO ここで先に画像関係の処理をする
        var imageWriteResult = true
        switch checkIconState() {
        case .Create:
            self.imagePath = DBProvider.createImagePath(filename: NSUUID().uuidString)
            imageWriteResult = DBProvider.sharedInstance.saveImageInDocumentDirectory(image: iconImage!, path: imagePath)
        case .Delete:
            // imagePathを使ってディレクトリの画像を削除する
            self.imagePath = ""
            print("アイコン_なにもしません")
        case .Update:
            // imagePathを使ってディレクトリの画像を削除する
            // 新しいイメージパスを作成して、プロパティに設定 & ディレクトリに画像を書き込み
            print("アイコン_更新します")
        default:
            print("アイコン_なにもしません")
            break
        }
        
        if(imageWriteResult == false){
            print("ファイルの書き込みに失敗しました!")
        }else{
            print("ファイルの書き込みに成功しました!")
        }
        
        let group = getChartGroupObject()
        var diffNumberOfItems = 0
        if(passedData != nil){
            diffNumberOfItems = numberOfItems - passedData!.labels.count
        }
        
        DBProvider.sharedInstance.addGroup(group: group,diffNumOfItems:diffNumberOfItems)

        // 画面を閉じる
        view.completeWritingToDatabase()
    }
    
    func onTapTrashButton() {
        // TODO 確認ダイアログを表示する
        
        DBProvider.sharedInstance.deleteGroup(id: self.passedData!.id)
        view.completeWritingToDatabase()
    }
    
    // 問題なければ空文字を、データに不正があればエラーメッセージを返す
    private func validateData() -> String{
        if(title == ""){
            return "タイトルが未入力です"
        }
        if(axisMaximum == 0){
            return "グラフの最大値が不正です"
        }
        for i in 0..<chartLabels.count{
            if(chartLabels[i] == ""){
                return "項目名が空です"
            }
        }
        return ""
    }
    
    private func getChartGroupObject() -> ChartGroup{
        var group:ChartGroup? = nil
        if(passedData == nil){
            group = ChartGroup(value: ["title":title,"color":selectedColor.toString(),"maximum":axisMaximum,"labels":Array(chartLabels.prefix(numberOfItems)),"imagePath":imagePath])
        }else{
            group = ChartGroup(value: ["id":passedData!.id,"title":title,"color":selectedColor.toString(),"maximum":axisMaximum,"labels":Array(chartLabels.prefix(numberOfItems)),"createdAt":passedData!.createdAt,"charts":passedData!.charts,"sortedIndex":passedData!.sortedIndex,"orderBy":passedData!.orderBy])
        }
        return group!
    }
    
    private func checkIconState() -> GroupIconState{
        if(imagePath == "" && iconImage != nil){
            return .Create
        }
        if(imagePath != ""){
            if(iconImage == nil){
                return .Delete
            }
            if(iconImage != nil && isIconChange){
                return .Update
            }
        }
        return .None
    }
    
    private enum GroupIconState{
        case Create
        case Delete
        case Update
        case None
    }
}

// GroupCreatePresenterが実装するプロトコル
// Viewから呼び出されるインターフェースを定義する
protocol GroupCreatePresenterInput {
    var title:String{get}
    var chartData:RadarChartData{get}
    var chartLabels:[String]{get}
    var imagePath:String{get}
    var sliderLabel:[String]{get}
    var selectedColor:UIColor{get set}
    var numberOfItems:Int{get set}
    var axisMaximum:Double{get set}
    func viewDidLoad(passedData:ChartGroup?)
    func didSelectColor(color:UIColor)
    func didSliderValueChanged(index:Int)
    func titleTextFieldDidEndEditing(text:String)
    func labelTextFieldDidEndEditing(index:Int,text:String)
    func axisMaximumTextFieldDidEndEditing(text:String)
    func onTapIconButton()
    func onTapSaveButton()
    func onTapTrashButton()
    func didCropToImage(image:UIImage)
}

// GroupCreateViewControllerが実装するプロトコル
// Presenterから呼び出されるインターフェースを定義する
protocol GroupCreaterPresenterOutput:AnyObject {
    func reflectThePassedData(iconImage:UIImage?)
    func updateNumberOfItems(num:Int,chartLabels:[String])
    func updateColor(color:UIColor)
    func setChartDataSource()
    func notifyChartDataChanged()
    func onUpdateChartLabel()
    func showValidateDialog(text:String)
    func completeWritingToDatabase()
    func showIconActionSheet(alert:UIAlertController)
    func showImagePicker(picker:UIImagePickerController)
    func deleteImage()
}
