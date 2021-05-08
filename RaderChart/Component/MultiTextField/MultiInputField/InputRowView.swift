//
//  InputRowView.swift
//  RaderChart
//
//  Created by M Aoshima on 2021/05/04.
//  Copyright © 2021 aoshima. All rights reserved.
//

import UIKit

class InputRowView: UIView {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var stepper: UIStepper!
    
    private var currentValue:Double = 0
    private var textValue:String{
        get{
            return String(Int(currentValue))
        }
        set{
            currentValue = Double(newValue) ?? 0
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
    
    func setup(label:String,maximum:Int,viewController:UIViewController){
        textField.delegate = self
        self.label.text = label
        currentValue = round(Double(maximum / 2))
        self.textField.text = textValue
        self.stepper.value = currentValue
        self.stepper.stepValue = Double(maximum / 10)
        viewController.addCloseButtonToTextFieldKeyboard(textField: self.textField)
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        currentValue = sender.value
        textField.text = textValue
    }
}

extension InputRowView:UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        textValue = textField.text ?? ""
        stepper.value = currentValue
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
