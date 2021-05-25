//
//  ChartCreateViewController.swift
//  RadarChart
//
//  Created by M Aoshima on 2021/05/03.
//  Copyright © 2021 aoshima. All rights reserved.
//

import UIKit
import Charts

class ChartCreateViewController: UIViewController,MultiInputFieldOutput {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var myRadarChartView: ChartForCreateScreen!
    @IBOutlet weak var maximumLabel: UILabel!
    @IBOutlet weak var totalAverageLabel: UILabel!
    @IBOutlet weak var multiInputView: MultiInputField!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var trashButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIButton!
    var activeField: UIView?
    
    private var presenter:ChartCreatePresenterInput!
    var groupData:ChartGroup!
    var editChartObject:MyChartObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        // setup Navigation Item
        self.navigationItem.title = (editChartObject == nil) ? "チャート新規作成" : "チャート編集"
        if(editChartObject == nil){
            let leftButton = UIBarButtonItem(title: "閉じる", style: UIBarButtonItem.Style.plain, target: self, action: #selector(onTapCloseButton(_:)))
            self.navigationItem.leftBarButtonItem = leftButton
            
            trashButton.isEnabled = false
            trashButton.tintColor = UIColor.clear
        }else{
            let leftButton = UIBarButtonItem(title: "保存", style: UIBarButtonItem.Style.plain, target: self, action: #selector(onTapSaveButton(_:)))
            self.navigationItem.leftBarButtonItem = leftButton
        }
        
        // setup title
        titleTextField.delegate = self
        
        // setup Chart
        myRadarChartView.xAxis.labelFont = .systemFont(ofSize: 15,weight: .regular)
        myRadarChartView.yAxis.axisMaximum = Double(groupData.maximum)
        myRadarChartView.yAxis.axisRange = Double(groupData.maximum)
        
        // setup Text
        self.maximumLabel.text = "グラフの最大値：\(Int(groupData.maximum))"
        
        // setup CommentView
        commentTextView.layer.borderColor = UIColor.gray.cgColor
        commentTextView.layer.borderWidth = 0.2
        commentTextView.layer.cornerRadius = 10
        commentTextView.layer.masksToBounds = true
        commentTextView.delegate = self
        addCloseButtonToTextViewKeyboard(textView: commentTextView)
        
        // setup Presenter
        self.presenter = ChartCreatePresenter(view: self)
        presenter.viewDidLoad(groupData: self.groupData,editChartObject: self.editChartObject)
        
        saveButton.layer.borderColor = UIColor.systemBlue.cgColor
        
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
        dismissScreen()
    }
    
    @IBAction func onTapColorButton(_ sender: Any) {
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
    
    @IBAction func onTapSaveButton(_ sender: Any) {
        presenter.onTapSaveButton()
    }
    
    @IBAction func onTapTrashButton(_ sender: Any) {
        let dialog = UIAlertController(title: "このチャートを削除しますか？", message: "この操作は取り消せません。", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "削除", style: .destructive) { (action:UIAlertAction) in
            self.presenter.deleteChart()
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        dialog.addAction(deleteAction)
        dialog.addAction(cancelAction)
        self.present(dialog, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ChartCreateViewController:ChartCreatePresenterOutput{
    // 最初に一回だけ呼び出す
    func InitializeChart() {
        (myRadarChartView.xAxis.valueFormatter as! RowXAxisFormatter).setLabel(labels: presenter.chartLabel)
        myRadarChartView.yAxis.axisMaximum = Double(groupData.maximum)
        myRadarChartView.data = presenter.chartData
        myRadarChartView.notifyDataSetChanged()
    }
    
    func reflectEditData(myChartObject: MyChartObject) {
        titleTextField.text = myChartObject.title
        commentTextView.text = myChartObject.note
    }
    
    func setupMultiInputView(labels: [String],values:[Double], axisMaximum: Double) {
        multiInputView.initialize(labels: labels,values: values, axisMaximum: axisMaximum, viewController: self)
    }
    
    func updateTotalAverageLabel(text: String) {
        totalAverageLabel.text = text
    }
    
    func updateChart() {
        myRadarChartView.data = presenter.chartData
        (myRadarChartView.xAxis.valueFormatter as! RowXAxisFormatter).setLabel(labels: presenter.chartLabel)
        myRadarChartView.data?.notifyDataChanged()
        myRadarChartView.notifyDataSetChanged()
    }
    
    func showValidateDialog(message: String) {
        let dialog = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(dialog, animated: true, completion: nil)
    }
    
    func dismissScreen(){
        if(editChartObject == nil){
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// タイトルTextField
extension ChartCreateViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField.text != nil && textField.text != ""){
            presenter.onChangeChartTitle(text: textField.text!)
        }
    }
}

// メモTextView
extension ChartCreateViewController:UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        activeField = textView
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        activeField = nil
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text != nil && textView.text != ""){
            presenter.onChangeNote(text: textView.text!)
        }
    }
}
