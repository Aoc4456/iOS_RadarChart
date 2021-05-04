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
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.axis = .vertical
        self.alignment = .fill
        self.distribution = .fillEqually
        self.spacing = 15
        
        for i in 0..<5{
            let row = InputRowView()
            row.label.text = "項目\(i)"
            self.addArrangedSubview(row)
        }
    }
}
