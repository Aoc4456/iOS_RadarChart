//
//  MultiEditText.swift
//  RaderChart
//
//  Created by M Aoshima on 2021/04/24.
//  Copyright © 2021 aoshima. All rights reserved.
//

import UIKit

class MultiEditText: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.backgroundColor = .orange
        
        let textview1 = UITextView()
        textview1.backgroundColor = .blue
        self.addSubview(textview1)
        
        let textView2 = UITextView()
        textView2.backgroundColor = .red
        self.addSubview(textView2)
        
        let textView3 = UITextView()
        textView3.backgroundColor = .yellow
        self.addSubview(textView3)
    }
    
}
