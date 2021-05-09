//
//  ChartCreateViewController.swift
//  RaderChart
//
//  Created by M Aoshima on 2021/05/03.
//  Copyright © 2021 aoshima. All rights reserved.
//

import UIKit
import Charts

class ChartCreateViewController: UIViewController,MultiInputFieldOutput {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var myRadarChartView: SampleChartInCreateScreen!
    @IBOutlet weak var maximumLabel: UILabel!
    @IBOutlet weak var multiInputView: MultiInputField!
    var activeField: UIView?
    
    private var presenter:ChartCreatePresenterInput!
    var groupData:ChartGroup!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup Navigation Item
        self.navigationItem.title = "チャート新規作成"
        let leftButton = UIBarButtonItem(title: "閉じる", style: UIBarButtonItem.Style.plain, target: self, action: #selector(onTapCloseButton(_:)))
        self.navigationItem.leftBarButtonItem = leftButton
        
        // setup Chart
        myRadarChartView.yAxis.axisMaximum = Double(groupData.maximum)
        myRadarChartView.yAxis.axisRange = Double(groupData.maximum)
        
        // setup Text
        self.maximumLabel.text = "グラフの最大値：\(groupData.maximum)"
        
        // setup Presenter
        self.presenter = ChartCreatePresenter(view: self)
        presenter.viewDidLoad(groupData: self.groupData)
        
        // setup TextField keyboard observer
        // キーボードでTextFieldが隠れないようにするため
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ChartCreateViewController.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ChartCreateViewController.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc func onTapCloseButton(_ sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    // キーボードでTextFieldが隠れないようにする
    @objc func keyboardWillShow(notification:NSNotification){
        // キーボードのサイズを取得
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        
        // 枠のサイズを取得
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardFrame.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect = self.view.frame
        aRect.size.height -= keyboardFrame.height
        if(activeField != nil){
            if(!aRect.contains(activeField!.frame.origin)){
                scrollView.scrollRectToVisible(activeField!.frame, animated: true)
            }
        }
    }
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInstes = UIEdgeInsets.zero
        scrollView.contentInset = contentInstes
        scrollView.scrollIndicatorInsets = contentInstes
    }
    
    // Custom View Delegate
    func onChangeInputValue(index: Int, value: Double) {
        presenter.onChangeInputValue(index: index, value: value)
    }
}

extension ChartCreateViewController:ChartCreatePresenterOutput{
    // 最初に一回だけ呼び出す
    func InitializeChart() {
        (myRadarChartView.xAxis.valueFormatter as! RowXAxisFormatter).setLabel(labels: Array(groupData.labels))
        myRadarChartView.yAxis.axisMaximum = Double(groupData.maximum)
        myRadarChartView.data = presenter.chartData
        myRadarChartView.notifyDataSetChanged()
    }
    
    func setupMultiInputView(labels: [String],values:[Double], axisMaximum: Double) {
        multiInputView.initialize(labels: labels,values: values, axisMaximum: axisMaximum, viewController: self)
    }
    
    func updateChart() {
        myRadarChartView.data = presenter.chartData
        myRadarChartView.data?.notifyDataChanged()
        myRadarChartView.notifyDataSetChanged()
    }
}
