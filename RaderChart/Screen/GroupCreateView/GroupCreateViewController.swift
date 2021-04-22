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

class GroupCreateViewController: UIViewController,GroupCreaterPresenterOutput {
    
    private var presenter:GroupCreatePresenterInput!
    
    private var colorPicker = UIColorPickerViewController()
    @IBOutlet weak var colorPickerView: UIView!
    @IBOutlet weak var stepSlider: StepSlider!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var raderChart: RadarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup presenter
        self.presenter = GroupCreatePresenter(view: self)
        
        // setup navigation item
        self.navigationItem.title = "グループ作成"
        let leftButton = UIBarButtonItem(title: "閉じる", style: UIBarButtonItem.Style.plain, target: self, action: #selector(onTapCloseButton(_:)))
        self.navigationItem.leftBarButtonItem = leftButton
        
        // setupSlider
        stepSlider.labels = presenter.sliderLabel;
        
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
    
    // presenter delegate
    func updateNumberOfItemsLabel(num: Int) {
        sliderLabel.text = num.description
    }
    
    // presenter delegate
    func updateColor(color: UIColor) {
        colorPickerView.backgroundColor = color
    }
    
    // presenter delegate
    func updateSampleChart() {
        raderChart.data = RadarChartData(dataSet: presenter.chartData)
    }
}

// カラーピッカーdelegate
extension GroupCreateViewController: UIColorPickerViewControllerDelegate{
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        presenter.didSelectColor(color: viewController.selectedColor)
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
    }
}
