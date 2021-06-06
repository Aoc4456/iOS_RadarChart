//
//  ViewController.swift
//  RadarChart
//
//  Created by aoshima on 2021/04/09.
//  Copyright © 2021 aoshima. All rights reserved.
//

import UIKit
import Charts
import StoreKit

class GroupListViewController: UIViewController {
    
    private var presenter:GroupListPresenterInput!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toSortButton: UIBarButtonItem!
    
    private var dataPassedToGroupEdit : ChartGroup? = nil
    private var dataPassedToChartList : ChartGroup? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup Presenter
        self.presenter = GroupListPresenter(view: self)
        
        // setup Navigation Item
        self.navigationItem.title = "グループ"
        
        // setup tableView
        tableView.register(UINib(nibName: "GroupListCell", bundle: nil), forCellReuseIdentifier: "customCell")
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPressed))
        longPressRecognizer.delegate = self
        tableView.addGestureRecognizer(longPressRecognizer)
        tableView.rowHeight = 80
        
        // レビュー訴求
        checkRequestReview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.fetchDataFromDatabase()
        toSortButton.isEnabled = presenter.isEnableSortButton
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // グループ編集画面への遷移
        if(segue.identifier == "toGroupCreateViewController"){
            if(dataPassedToGroupEdit != nil){
                let nextNaviVC = segue.destination as? UINavigationController
                let nextVC = nextNaviVC?.topViewController as? GroupCreateViewController
                nextVC?.passedData = dataPassedToGroupEdit
            }
            dataPassedToGroupEdit = nil
        }

        // チャート一覧画面への遷移
        if(segue.identifier == "toChartCollectionViewController"){
            if(dataPassedToChartList != nil){
                let nextVC = segue.destination as! ChartCollectionViewController
                nextVC.groupData = dataPassedToChartList
            }
            dataPassedToChartList = nil
            navigationItem.backButtonTitle = "戻る"
        }
    }
    
    // 10回起動毎に、レビュー訴求する
    private func checkRequestReview(){
        if(loadAppLaunchCount() < 10){
            incrementAppLaunchCount()
        }else{
            resetAppLaunchCount()
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
}

extension GroupListViewController:GroupListPresenterOutput{
    func reloadTableView() {
        tableView.reloadData()
    }
}

extension GroupListViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataPassedToChartList = presenter.dataList[indexPath.row]
        performSegue(withIdentifier: "toChartCollectionViewController", sender: nil)
    }
}

extension GroupListViewController:UITableViewDataSource{
    // セルを返す　ここでデータを参照してビューに反映する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! GroupListCell
        let data = presenter.dataList[indexPath.row]
        let icon = presenter.iconImageMap[indexPath.row]
        cell.setData(group: data, vc: self, icon: icon)
        return cell
    }
    
    // セルの数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(presenter.dataList.count == 0){
            tableView.setEmptyMessage("+ ボタンをタップしてグループを作成しましょう！")
        }else{
            tableView.restore()
        }
        return presenter.dataList.count
    }
    
    // チャート部分は、テーブルビューのdelegateでタップイベントを検知できないので、別途 Gesture Recognizer を設定する
    @objc func onChartTapped(recognizer:UITapGestureRecognizer){
        let tappedLocation = recognizer.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: tappedLocation)
        if indexPath == nil{
            return
        }
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        dataPassedToChartList = presenter.dataList[indexPath!.row]
        performSegue(withIdentifier: "toChartCollectionViewController", sender: nil)
    }
}

extension GroupListViewController:UIGestureRecognizerDelegate{
    @objc func cellLongPressed(recognizer: UILongPressGestureRecognizer){
        if(recognizer.state == .began){
            let point = recognizer.location(in: tableView)
            let indexPath = tableView.indexPathForRow(at: point)
            if(indexPath != nil){
                let index = indexPath!.row
                dataPassedToGroupEdit = presenter.dataList[index]
                // 遷移先のCreateViewController に データを渡す
                performSegue(withIdentifier: "toGroupCreateViewController", sender: nil)
            }
        }
    }
}
