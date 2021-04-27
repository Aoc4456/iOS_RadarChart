//
//  CommonExtension.swift
//  RaderChart
//
//  Created by M Aoshima on 2021/04/27.
//  Copyright © 2021 aoshima. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
