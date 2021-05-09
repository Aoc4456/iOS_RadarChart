//
//  InputRowView.swift
//  RaderChart
//
//  Created by M Aoshima on 2021/05/04.
//  Copyright © 2021 aoshima. All rights reserved.
//

import UIKit
import Foundation

class InputRowView: UIView {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var stepper: UIStepper!
    
    private var parentView:MultiInputField?
    
    private var currentValue:Double = 0
    private var textValue:String{
        get{
            return String(Int(currentValue))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }

    private func loadNib() {
        if let view = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            self.addSubview(view)
        }
    }
    
    func setup(label:String,maximum:Int,viewController:UIViewController,parentView:MultiInputField){
        self.parentView = parentView
        textField.delegate = self
        self.label.text = label
        currentValue = round(Double(maximum) * 0.6) // MARK: チャートと合わせる
        self.textField.text = textValue
        
        self.stepper.maximumValue = Double(maximum * 2)
        self.stepper.value = currentValue
        self.stepper.stepValue = getStep(maximum: maximum)
        viewController.addCloseButtonToTextFieldKeyboard(textField: self.textField)
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        currentValue = sender.value
        textField.text = textValue
        // 親に通知
    }
    
    private func getStep(maximum:Int) -> Double{
        let digits = String(maximum).count
        if(digits < 3){
            return 1
        }else{
            return pow(10, Double(digits - 2))
        }
    }
}

extension InputRowView:UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        var value = 0.0
        if(textField.text != nil && Double(textField.text!) != nil){
            value = Double(textField.text!)!
        }
        
        if(value > stepper.maximumValue){
            value = stepper.maximumValue
            textField.text = String(Int(value))
        }
        
        currentValue = value
        stepper.value = currentValue
        parentView?.parentVC.activeField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        parentView?.parentVC.activeField = textField
    }
}
