//
//  ListTile.swift
//  RadarChart
//
//  Created by M Aoshima on 2021/05/27.
//  Copyright © 2021 aoshima. All rights reserved.
//

import UIKit

class ListTile: UIView {

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
    
    override var intrinsicContentSize: CGSize{
        return CGSize(width: frame.width, height: 60)
    }

}
