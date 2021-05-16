//
//  DateUtil.swift
//  RadarChart
//
//  Created by M Aoshima on 2021/05/01.
//  Copyright © 2021 aoshima. All rights reserved.
//

import Foundation

extension Date{
    func toLocaleDateString() -> String{
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        formatter.dateFormat = "M'月'd'日' HH:mm"
        
        return formatter.string(from: self)
    }
    
    func toLocaleDateStringShort() -> String{
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        formatter.dateFormat = "M/d HH:mm"
        
        return formatter.string(from: self)
    }
}
