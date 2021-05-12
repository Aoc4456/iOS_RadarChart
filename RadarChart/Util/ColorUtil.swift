//
//  ColorUtil.swift
//  RaderChart
//

import Foundation
import UIKit

extension UIColor{
    func toString() -> String{
        return CIColor(cgColor: self.cgColor).stringRepresentation
    }
}

extension String{
    func toUIColor() -> UIColor{
        return UIColor(ciColor: CIColor(string: self))
    }
}
