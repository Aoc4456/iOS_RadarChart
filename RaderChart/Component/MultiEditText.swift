//
//  MultiEditText.swift
//  RaderChart
//
//  Created by M Aoshima on 2021/04/24.
//  Copyright © 2021 aoshima. All rights reserved.
//

import UIKit

class MultiEditText: UIStackView {
    
    private var numberOfItems = 5
    private var textFieldArray:[UITextField] = []
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.axis = .vertical
        self.alignment = .fill
        self.distribution = .fillEqually
        self.spacing = 10
        
        for i in 0..<numberOfItems {
            let textField = UITextField()
            textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
            textField.borderStyle = .roundedRect
            textField.placeholder = "項目名\(i+1)"
            textFieldArray.append(textField)
            self.addArrangedSubview(textField)
        }
    }
    
    func changeNumberOfItems(newNum:Int){
        let difference = abs(numberOfItems - newNum)
        if(numberOfItems < newNum ){ // 項目が増加
            appendItems(num: difference)
        }else if(numberOfItems > newNum){ // 項目が減少
            removeItems(num: difference)
        }
        numberOfItems = newNum
    }
    
    private func appendItems(num:Int){
        let currentNumber = numberOfItems
        for i in currentNumber..<(currentNumber + num){
            let textField = UITextField()
            textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
            textField.borderStyle = .roundedRect
            textField.placeholder = "項目名\(i+1)"
            textFieldArray.append(textField)
            self.addArrangedSubview(textField)
        }
    }
    
    private func removeItems(num:Int){
        for _ in 0..<num{
            let textField = textFieldArray.last!
            removeArrangedSubview(textField)
            textField.removeFromSuperview()
            textFieldArray.removeLast()
        }
    }
}
