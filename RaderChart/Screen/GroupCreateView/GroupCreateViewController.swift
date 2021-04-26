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

class GroupCreateViewController: UIViewController{
    
    private var presenter:GroupCreatePresenterInput!
    
    private var colorPicker = UIColorPickerViewController()
    @IBOutlet weak var colorPickerView: UIView!
    @IBOutlet weak var stepSlider: StepSlider!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var raderChart: GroupCreateSampleChart!
    @IBOutlet weak var multiEditTextField: MultiEditText!
    @IBOutlet weak var axisMaximumField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup presenter
        self.presenter = GroupCreatePresenter(view: self)
        
        // setup navigation item
        self.navigationItem.title = "グループ作成"
        let leftButton = UIBarButtonItem(title: "閉じる", style: UIBarButtonItem.Style.plain, target: self, action: #selector(onTapCloseButton(_:)))
        self.navigationItem.leftBarButtonItem = leftButton
        
        // setup Slider
        stepSlider.labels = presenter.sliderLabel;
        stepSlider.index = UInt(presenter.numberOfItems - 3)
        
        // setup axisMaximum
        axisMaximumField.text = presenter.axisMaximum.description
        
        // setup MultiEditText
        multiEditTextField.setViewController(viewController: self)
        
        // observe keyboard
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
    
    // TextFieldにフォーカスされたとき、キーボードでTextFieldが隠れないようにする
    @objc func keyboardWillShow(notification:NSNotification){
        // キーボードのサイズを取得
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        
        // 取得したサイズをもとにビューを調節
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= keyboardFrame.height
        }
    }
    @objc func keyboardWillHide(notification:NSNotification){
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y = 0
        }
    }
}

// Presenterから呼び出されるインターフェース
// 描画指示を受けてUIを更新する
extension GroupCreateViewController:GroupCreaterPresenterOutput{
    
    func updateNumberOfItems(num: Int) {
        sliderLabel.text = num.description
        multiEditTextField.changeNumberOfItems(newNum: num)
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
}

// カラーピッカーdelegate
extension GroupCreateViewController: UIColorPickerViewControllerDelegate{
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        presenter.didSelectColor(color: viewController.selectedColor)
    }
}
