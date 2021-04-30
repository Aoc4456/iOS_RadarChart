//
//  ColorUtil.swift
//  RaderChart
//

import Foundation
import UIKit

class ColorUtil{
    
    static func convertColorToString(color:UIColor) -> String{
        let colorString = CIColor(cgColor: color.cgColor).stringRepresentation
        return colorString
    }
    
    static func convertStringToColor(colorString:String) -> UIColor{
        let color = UIColor(ciColor: CIColor(string: colorString))
        return color
    }
}
