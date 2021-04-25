//
//  MultiEditText.swift
//  RaderChart
//
//  Created by M Aoshima on 2021/04/24.
//  Copyright © 2021 aoshima. All rights reserved.
//

import UIKit

class MultiEditText: UIStackView {
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.axis = .vertical
        self.alignment = .fill
        self.distribution = .fillEqually
        self.spacing = 10
        
        let textview1 = UITextField()
        textview1.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textview1.borderStyle = .roundedRect
        self.addArrangedSubview(textview1)
        
        let textView2 = UITextField()
        textView2.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textView2.borderStyle = .roundedRect
        self.addArrangedSubview(textView2)
        
        let textView3 = UITextField()
        textView3.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textView3.borderStyle = .roundedRect
        self.addArrangedSubview(textView3)
        
        let textView4 = UITextField()
        textView4.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textView4.borderStyle = .roundedRect
        self.addArrangedSubview(textView4)
    }
}
