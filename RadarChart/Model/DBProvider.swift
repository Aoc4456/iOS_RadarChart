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
    
    // グループを全件取得 (ユーザーの決めた並び順)
    func getGroupList() -> Array<ChartGroup>{
        let results = db.objects(ChartGroup.self).sorted(byKeyPath: "rate", ascending: true)
        return Array(results)
    }
    
    // グループをidから1件取得
    func getGroup(id:String) -> ChartGroup {
        let object = db.objects(ChartGroup.self).filter("id = %@", id)
        return object.first!
    }
    
    // グループを追加 または 更新
    func addGroup(group:ChartGroup,diffNumOfItems:Int){
        db.beginWrite()
        
        if(diffNumOfItems < 0){
            // ソート対象の項目が削除されたら、ソート条件を初期値にリセットする
            if(group.sortedIndex >= 0){
                if(group.sortedIndex + 1 > group.labels.count){
                    group.sortedIndex = -1
                    group.orderBy = "ASC"
                }
            }
            
            // 関連するチャートから、減った項目の値を削除
            group.charts.forEach{
                $0.values.removeLast(abs(diffNumOfItems))
            }
        }else if(diffNumOfItems > 0){ // 項目数が増えたらデフォルト値で埋める
            group.charts.forEach{
                let addValue = group.maximum * 0.6
                for _ in 0..<diffNumOfItems{
                    $0.values.append(addValue)
                }
            }
        }
        
        db.add(group,update: .modified)
        
        try! db.commitWrite()
    }
    
    // グループと、グループに属するチャートを削除
    func deleteGroup(id:String){
        let object = db.objects(ChartGroup.self).filter("id = %@", id)[0]
        
        if(object.iconFileName != ""){
            deleteImageInDocumentDirectory(fileName: object.iconFileName)
        }
        try! db.write {
            db.delete(object.charts)
            db.delete(object)
        }
    }
    
    // ASC,DESCを変更
    func changeAscDesc(chartGroup:ChartGroup){
        db.beginWrite()
        if(chartGroup.orderBy == "ASC"){
            chartGroup.orderBy = "DESC"
        }else{
            chartGroup.orderBy = "ASC"
        }
        try! db.commitWrite()
    }
    
    // ソート項目を変更
    func changeSortIndex(group:ChartGroup,index:Int){
        db.beginWrite()
        group.sortedIndex = index
        try! db.commitWrite()
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
    
    // ソートされたチャートを取得 TODO enum に置き換える
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
                if(chart.values.sum() > chart2.values.sum()){
                    return group.orderBy == "DESC"
                }
                return group.orderBy == "ASC"
            })
        }
        
        // タイトル
        if(group.sortedIndex == -4){
            sortedChartArray = chartArray.sorted(by: { chart, chart2 -> Bool in
                if(chart.title > chart2.title){
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
    
    //
    // 画像保存に関する関数
    //
    private func getDocumentsDirectoryURL() -> NSURL{
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
    }
    
    func createImagePath(filename:String) -> String{
        let imegeFileUrl = getDocumentsDirectoryURL().appendingPathComponent(filename)
        return imegeFileUrl!.path
    }
    
    func saveImageInDocumentDirectory(image:UIImage,fileName:String) -> Bool{
        let jpegImage = image.jpegData(compressionQuality: 1)
        let fullPath = createImagePath(filename: fileName)
        do{
            try jpegImage!.write(to: URL(fileURLWithPath: fullPath),options: .atomic)
        }catch{
            print(error)
            return false
        }
        return true
    }
    
    func deleteImageInDocumentDirectory(fileName:String){
        let fullPath = createImagePath(filename: fileName)
        do{
            try FileManager.default.removeItem(at: URL(fileURLWithPath: fullPath))
        }catch{
            print(error)
        }
    }
    
    func loadImage(filename:String) -> UIImage?{
        let fullPath = createImagePath(filename: filename)
        return UIImage(contentsOfFile: fullPath)
    }
}
