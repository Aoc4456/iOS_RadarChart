//
//  MultiInputField.swift
//  RaderChart
//
//  Created by M Aoshima on 2021/05/04.
//  Copyright © 2021 aoshima. All rights reserved.
//

import Foundation
import UIKit

class MultiInputField:UIStackView{

    var parentVC:MultiInputFieldOutput!
    
    private var labels:[String]!
    private var axisMaximum:Double!
    
    private let tagConstant = 53278
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.axis = .vertical
        self.alignment = .fill
        self.distribution = .fillEqually
        self.spacing = 15
    }
    
    func initialize(labels:[String],values:[Double],axisMaximum:Double,viewController:UIViewController){
        self.parentVC = viewController as? MultiInputFieldOutput
        self.labels = labels
        self.axisMaximum = axisMaximum
        
        for i in 0..<labels.count{
            let row = createRowView(index: i, label: labels[i],value: values[i],viewController: viewController)
            self.addArrangedSubview(row)
        }
    }
    
    private func createRowView(index:Int,label:String,value:Double,viewController:UIViewController) -> InputRowView{
        let row = InputRowView()
        row.setup(label: label,value: value, maximum: axisMaximum,viewController: viewController, parentView: self)
        row.tag = tagConstant + index
        return row
    }
    
    func onChangeValue(value:Double,view:UIView){
        let valueString = value.description
        let index = view.tag - tagConstant
        print("\(index)番目の値：\(valueString)")
    }
}

protocol MultiInputFieldOutput {
    var activeField:UIView?{get set}
    func onChangeInputValue(index:Int,value:Double)
}
