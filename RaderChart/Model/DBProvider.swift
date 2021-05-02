//
//  DBProvider.swift
//  RaderChart
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
    
    // グループを全件取得 (作成日の昇順)
    func getGroupList() -> Array<ChartGroup>{
        let results = db.objects(ChartGroup.self).sorted(byKeyPath: "createdAt", ascending: true)
        return Array(results)
    }
    
    // グループにレコードを新規追加
    func addGroup(object:ChartGroup){
        try! db.write {
            db.add(object,update: .all)
        }
    }
    
    // グループを削除 TODO: グループに所属するチャートも全て削除する
    func deleteGroup(id:String){
        let object = db.objects(ChartGroup.self).filter("id = %@", id)
        try! db.write {
            db.delete(object)
        }
    }
}
