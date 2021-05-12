//
//  DateUtil.swift
//  RaderChart
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
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        
        return formatter.string(from: self)
    }
}
