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
    
    private let tagConstant = 53278
    
    private var labels:[String]!
    private var axisMaximum:Int!
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.axis = .vertical
        self.alignment = .fill
        self.distribution = .fillEqually
        self.spacing = 15
    }
    
    func initialize(labels:[String],axisMaximum:Int,viewController:UIViewController){
        self.labels = labels
        self.axisMaximum = axisMaximum
        
        for i in 0..<labels.count{
            let row = createRowView(index: i, label: labels[i],viewController: viewController)
            self.addArrangedSubview(row)
        }
    }
    
    private func createRowView(index:Int,label:String,viewController:UIViewController) -> InputRowView{
        let row = InputRowView()
        row.setup(label: label, maximum: axisMaximum,viewController: viewController)
        row.tag = tagConstant + index
        return row
    }
}
