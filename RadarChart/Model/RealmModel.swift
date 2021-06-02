//
//  RealmModel.swift
//  RadarChart
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
    @objc dynamic var iconFileName : String = ""
    @objc dynamic var maximum : Double = 0
    let labels = List<String>()
    @objc dynamic var createdAt = Date()
    @objc dynamic var updatedAt = Date()
    @objc dynamic var rate : Int = 0
    
    /**
     ソートする条件
     
     -1 = 作成日,   -2 = 更新日,  -3 = 合計値 , -4 = タイトル: 0以上の場合 = labelsのインデックス
     */
    @objc dynamic var sortedIndex : Int = -1
    @objc dynamic var orderBy : String = "ASC"
    
    // １対多の関係
    let charts = List<MyChartObject>()

    override static func primaryKey() -> String? {
        return "id"
    }
}

class MyChartObject:Object{
    @objc dynamic var id : String = NSUUID().uuidString
    @objc dynamic var title : String = ""
    @objc dynamic var color : String = ""
    let values = List<Double>()
    @objc dynamic var note : String = ""
    @objc dynamic var createdAt = Date()
    @objc dynamic var updatedAt = Date()
    // 逆方向の関連
    let group = LinkingObjects(fromType: ChartGroup.self, property: "charts").first
    override static func primaryKey() -> String? {
        return "id"
    }
}
