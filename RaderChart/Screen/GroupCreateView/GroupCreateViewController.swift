//
//  GroupCreateViewController.swift
//  RaderChart
//
//  Created by M Aoshima on 2021/04/11.
//  Copyright © 2021 aoshima. All rights reserved.
//

import UIKit
import StepSlider
import Charts

class GroupCreateViewController: UIViewController,MultiEditTextOutput{
    private var presenter:GroupCreatePresenterInput!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var titleTextField: UITextField!
    private var colorPicker = UIColorPickerViewController()
    @IBOutlet weak var colorPickerView: UIView!
    @IBOutlet weak var stepSlider: StepSlider!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var raderChart: GroupCreateSampleChart!
    @IBOutlet weak var multiEditTextField: MultiEditText!
    @IBOutlet weak var axisMaximumField: UITextField!
    var activeField: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup presenter
        self.presenter = GroupCreatePresenter(view: self)
        
        // setup navigation item
        self.navigationItem.title = "グループ作成"
        let leftButton = UIBarButtonItem(title: "閉じる", style: UIBarButtonItem.Style.plain, target: self, action: #selector(onTapCloseButton(_:)))
        self.navigationItem.leftBarButtonItem = leftButton
        
        // setup Title Field
        titleTextField.delegate = self
        
        // setup Slider
        stepSlider.labels = presenter.sliderLabel;
        stepSlider.index = UInt(presenter.numberOfItems - 3)
        
        // setup axisMaximum
        axisMaximumField.text = presenter.axisMaximum.description
        
        // setup MultiEditText
        multiEditTextField.setViewController(viewController: self)
        
        // setup TextField keyboard observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(GroupCreateViewController.keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(GroupCreateViewController.keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        
        presenter.viewDidLoad()
    }
    
    @objc func onTapCloseButton(_ sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapColorPickerView(_ sender: Any) {
        colorPicker.supportsAlpha = true // あとでfalseにして何が違うか確認する
        colorPicker.selectedColor = presenter.selectedColor
        colorPicker.delegate = self
        present(colorPicker, animated: true)
    }
    
    @IBAction func sliderValueChanged(_ sender: StepSlider) {
        presenter.didSliderValueChanged(index: Int(sender.index))
    }
    
    // delegate multi text field
    func textFieldDidEndEditing(index:Int,text:String){
        presenter.labelTextFieldDidEndEditing(index: index, text: text)
    }
    
    @IBAction func onTapSaveButton(_ sender: Any) {
        presenter.onTapSaveButton()
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
}

// Presenterから呼び出されるインターフェース
// 描画指示を受けてUIを更新する
extension GroupCreateViewController:GroupCreaterPresenterOutput{
    
    func updateNumberOfItems(num: Int,chartLabels:[String]) {
        sliderLabel.text = num.description
        multiEditTextField.changeNumberOfItems(newNum: num,labels:chartLabels)
    }
    
    func updateColor(color: UIColor) {
        colorPickerView.backgroundColor = color
        stepSlider.tintColor = color
        stepSlider.sliderCircleColor = color
    }
    
    // 最初に一度だけ呼び出す
    func setChartDataSource() {
        raderChart.data = presenter.chartData
        notifyChartDataChanged()
    }
    
    // チャートに関連するデータが変更されたときに呼ばれる
    func notifyChartDataChanged() {
        raderChart.data?.notifyDataChanged()
        raderChart.notifyDataSetChanged()
    }
    
    // チャートのラベルが変更されるとき
    func onUpdateChartLabel() {
        print(presenter.chartLabels)
        (raderChart.xAxis.valueFormatter as! RowXAxisFormatter).setLabel(labels: presenter.chartLabels)
        raderChart.notifyDataSetChanged()
    }
    
    // バリデーションで不正があったとき
    func showValidateDialog(text: String) {
        let dialog = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(dialog, animated: true, completion: nil)
    }
}

// タイトルTextFieldDelegate
extension GroupCreateViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        presenter.titleTextFieldDidEndEditing(text: textField.text ?? "")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// カラーピッカーdelegate
extension GroupCreateViewController: UIColorPickerViewControllerDelegate{
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        presenter.didSelectColor(color: viewController.selectedColor)
    }
}
