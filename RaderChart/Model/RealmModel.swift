//
//  RealmModel.swift
//  RaderChart
//
//  Created by M Aoshima on 2021/04/29.
//  Copyright © 2021 aoshima. All rights reserved.
//

import Foundation
import RealmSwift

class ChartGroup:Object{
    @objc dynamic var id : String = NSUUID().uuidString
    @objc dynamic var title : String = ""
    @objc dynamic var color : String = ""
    @objc dynamic var maximum : Double = 0
    let labels = List<String>()
    @objc dynamic var createdAt = Date()
    @objc dynamic var updatedAt = Date()

    override static func primaryKey() -> String? {
        return "id"
    }
}

class MyChartObject:Object{
    @objc dynamic var id : String = NSUUID().uuidString
    @objc dynamic var title : String = ""
    let values = List<Double>()
    @objc dynamic var createdAt = Date()
    @objc dynamic var updatedAt = Date()
    // MARK: 外部キーはいらないかも...
    @objc dynamic var groupId : String = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}
