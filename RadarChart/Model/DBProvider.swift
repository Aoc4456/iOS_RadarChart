//
//  DBProvider.swift
//  RadarChart
//
//

import Foundation
import RealmSwift

class DBProvider{
    // singleton
    // 各画面からの呼び出し方
    // 例：data = DBProvider.sharedInstance.getGroupList()
    static let sharedInstance = DBProvider()
    
    private var db:Realm
    
    private init(){
        db = try! Realm()
    }
    
    
    //
    // グループテーブル操作関数
    //
    
    // グループを全件取得 (作成日の古い順)
    func getGroupList() -> Array<ChartGroup>{
        let results = db.objects(ChartGroup.self).sorted(byKeyPath: "createdAt", ascending: true)
        return Array(results)
    }
    
    // グループをidから1件取得
    func getGroup(id:String) -> ChartGroup {
        let object = db.objects(ChartGroup.self).filter("id = %@", id)
        return object.first!
    }
    
    // グループを追加 または 更新
    func addGroup(object:ChartGroup,diffNumOfItems:Int){
        db.beginWrite()
        
        // 関連するチャートから、減った項目の値を削除
        if(diffNumOfItems < 0){
            object.charts.forEach{
                $0.values.removeLast(abs(diffNumOfItems))
            }
        }else if(diffNumOfItems > 0){ // 項目数が増えたらデフォルト値で埋める
            object.charts.forEach{
                let addValue = object.maximum * 0.6
                for _ in 0..<diffNumOfItems{
                    $0.values.append(addValue)
                }
            }
        }
        
        db.add(object,update: .modified)
        
        try! db.commitWrite()
    }
    
    // グループと、グループに属するチャートを削除
    func deleteGroup(id:String){
        let object = db.objects(ChartGroup.self).filter("id = %@", id)[0]
        try! db.write {
            db.delete(object.charts)
            db.delete(object)
        }
    }
    
    
    //
    // チャートテーブル操作関数
    //
    
    // チャート新規追加
    func addChart(groupId:String,chartObject:MyChartObject){
        db.beginWrite()
        let group = getGroup(id: groupId)
        group.charts.append(chartObject)
        try! db.commitWrite()
    }
    
    // チャート更新
    func updateChart(oldChartObject:MyChartObject,newChartObject:MyChartObject){
        db.beginWrite()
        newChartObject.id = oldChartObject.id
        newChartObject.createdAt = oldChartObject.createdAt
        
        db.add(newChartObject, update: .modified)
        try! db.commitWrite()
    }
    
    // チャート削除
    func deleteChart(id:String){
        let object = db.objects(MyChartObject.self).filter("id = %@", id)[0]
        try! db.write {
            db.delete(object)
        }
    }
    
    // ソートされたチャートを取得
    func getSortedCharts(group:ChartGroup) -> Array<MyChartObject>{
        let chartArray = Array(group.charts)
        var sortedChartArray = [MyChartObject]()
        
        // 作成日
        if(group.sortedIndex == -1){
            sortedChartArray = chartArray.sorted(by: { chart, chart2 -> Bool in
                if(chart.createdAt > chart2.createdAt){
                    return group.orderBy == "DESC"
                }
                return group.orderBy == "ASC"
            })
        }
        
        // 更新日
        if(group.sortedIndex == -2){
            sortedChartArray = chartArray.sorted(by: { chart, chart2 -> Bool in
                if(chart.updatedAt > chart2.updatedAt){
                    return group.orderBy == "DESC"
                }
                return group.orderBy == "ASC"
            })
        }
        
        // 合計値
        if(group.sortedIndex == -3){
            sortedChartArray = chartArray.sorted(by: { chart, chart2 -> Bool in
                if(chart.updatedAt > chart2.updatedAt){
                    return group.orderBy == "DESC"
                }
                return group.orderBy == "ASC"
            })
        }
        
        // 各項目の値
        if(group.sortedIndex >= 0){
            sortedChartArray = chartArray.sorted(by: { chart, chart2 -> Bool in
                if(chart.values[group.sortedIndex] > chart2.values[group.sortedIndex]){
                    return group.orderBy == "DESC"
                }
                return group.orderBy == "ASC"
            })
        }
        
        return sortedChartArray
    }
}
