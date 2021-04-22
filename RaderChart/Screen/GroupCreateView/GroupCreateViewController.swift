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

class GroupCreateViewController: UIViewController {
    
    private var selectedColor = UIColor.systemTeal
    private var colorPicker = UIColorPickerViewController()
    @IBOutlet weak var colorPickerView: UIView!
    @IBOutlet weak var stepSlider: StepSlider!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var raderChart: RadarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup navigation item
        self.navigationItem.title = "グループ作成"
        let leftButton = UIBarButtonItem(title: "閉じる", style: UIBarButtonItem.Style.plain, target: self, action: #selector(onTapCloseButton(_:)))
        self.navigationItem.leftBarButtonItem = leftButton
        
        stepSlider.labels = ["3","4","5","6","7","8"];
    }
    
    @objc func onTapCloseButton(_ sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapColorPickerView(_ sender: Any) {
        colorPicker.supportsAlpha = true // あとでfalseにして何が違うか確認する
        colorPicker.selectedColor = selectedColor
        colorPicker.delegate = self
        present(colorPicker, animated: true)
    }
    
    @IBAction func sliderValueChanged(_ sender: StepSlider) {
        sliderLabel.text = (sender.index + 3).description
    }
}

// カラーピッカーdelegate
extension GroupCreateViewController: UIColorPickerViewControllerDelegate{
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        selectedColor = viewController.selectedColor
        colorPickerView.backgroundColor = selectedColor
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
    }
}
