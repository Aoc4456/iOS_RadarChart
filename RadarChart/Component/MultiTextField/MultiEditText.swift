//
//  MultiEditText.swift
//  RadarChart
//
//  Created by M Aoshima on 2021/04/24.
//  Copyright © 2021 aoshima. All rights reserved.
//

import UIKit

class MultiEditText: UIStackView,UITextFieldDelegate {
    
    private var viewController:MultiEditTextOutput?
    private var numberOfItems = 5
    private var textFieldArray:[UITextField] = []
    private var textValueArray:[String] = []
    private let tagConstant = 32793
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.axis = .vertical
        self.alignment = .fill
        self.distribution = .fillEqually
        self.spacing = 10
        
        for i in 0..<numberOfItems {
            let textField = createTextField(index: i)
            textFieldArray.append(textField)
            self.addArrangedSubview(textField)
        }
    }
    
    func setViewController(viewController:MultiEditTextOutput){
        self.viewController = viewController
    }
    
    func changeNumberOfItems(newNum:Int,labels:[String]){
        let difference = abs(numberOfItems - newNum)
        if(numberOfItems < newNum ){ // 項目が増加
            appendItems(num: difference,labels: labels)
        }else if(numberOfItems > newNum){ // 項目が減少
            removeItems(num: difference)
        }
        numberOfItems = newNum
    }
    
    func setInitialLabels(labels:[String]){
        for i in 0..<labels.count{
            let textField = findViewWithTag(index: i)
            textField?.text = labels[i]
        }
    }
    
    private func appendItems(num:Int,labels:[String]){
        let currentNumber = numberOfItems
        for i in currentNumber..<(currentNumber + num){
            let textField = createTextField(index: i)
            textField.text = labels[i]
            textFieldArray.append(textField)
            self.addArrangedSubview(textField)
        }
    }
    
    private func createTextField(index:Int) -> UITextField{
        let textField = UITextField()
        textField.delegate = self
        textField.tag = createTag(index: index)
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.borderStyle = .roundedRect
        textField.text = "項目\(index+1)"
        return textField
    }
    
    private func removeItems(num:Int){
        for _ in 0..<num{
            let textField = textFieldArray.last!
            removeArrangedSubview(textField)
            textField.removeFromSuperview()
            textFieldArray.removeLast()
        }
    }
    
    private func createTag(index:Int) -> Int{
        return tagConstant + index
    }
    
    private func findViewWithTag(index:Int) -> UITextField?{
        let tag = tagConstant + index
        return superview?.viewWithTag(tag) as? UITextField
    }
    
    // delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let tag = textField.tag
        textField.resignFirstResponder()
        return true
    }
    
    // delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewController?.activeField = textField
    }
    
    // delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        viewController?.activeField = nil
        
        let index = textField.tag - tagConstant
        viewController?.textFieldDidEndEditing(index: index, text: textField.text ?? "")
    }
}

protocol MultiEditTextOutput{
    var activeField:UIView?{set get}
    func textFieldDidEndEditing(index:Int,text:String)
}
