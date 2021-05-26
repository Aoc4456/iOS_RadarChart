//
//  ChartCollectionViewController.swift
//  RadarChart
//
//  Created by M Aoshima on 2021/05/02.
//  Copyright © 2021 aoshima. All rights reserved.
//

import UIKit

class ChartCollectionViewController: UIViewController {
    
    private var presenter:ChartCollectionPresenterInput!
    var groupData : ChartGroup!
    var tappedIndex : Int?
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var orderItemButton: UIButton!
    @IBOutlet weak var ascDescButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = groupData.title
        
        // setup Presenter
        self.presenter = ChartCollectionPresenter(view: self)
        
        // setup CollectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ChartListCell", bundle: nil), forCellWithReuseIdentifier: "ListCell")
        collectionView.register(UINib(nibName: "ChartGridCell", bundle: nil), forCellWithReuseIdentifier: "GridCell")
        collectionView.delaysContentTouches = false
        
        // setup CollectionViewCell
        segmentView.selectedSegmentIndex = loadSegmentIndex()
        if(segmentView.selectedSegmentIndex == 0){
            collectionView.collectionViewLayout = getChartListCellFlowLayout(view: containerView)
        }else{
            collectionView.collectionViewLayout = getChartGridCellFlowLayout(view: containerView)
        }
        
        presenter.viewDidLoad(groupData: self.groupData)
    }

    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
        
        var flowLayout:UICollectionViewLayout? = nil
        if(sender.selectedSegmentIndex == 0){
            flowLayout = getChartListCellFlowLayout(view: containerView)
        }else{
            flowLayout = getChartGridCellFlowLayout(view: containerView)
        }
        
        collectionView.setCollectionViewLayout(flowLayout!, animated: true)
        saveSegmentIndex(index: sender.selectedSegmentIndex)
    }
    
    @IBAction func onTapOrderItemButton(_ sender: Any) {
        presenter.onTapSortItemButton()
    }
    
    @IBAction func onTapAscDescButton(_ sender: Any) {
        presenter.onTapAscDescButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // チャート新規作成
        if(segue.identifier == "toChartCreateViewController"){
            let nextNaviVC = segue.destination as? UINavigationController
            let nextVC = nextNaviVC?.topViewController as? ChartCreateViewController
            nextVC?.groupData = groupData
            nextVC?.editChartObject = nil
        }
        
        // 編集
        if(segue.identifier == "toChartCreateViewControllerPush"){
            let nextVC = (segue.destination as? ChartCreateViewController)
            nextVC?.groupData = groupData
            nextVC?.editChartObject = presenter.getTappedChartObject(index: tappedIndex!)
            navigationItem.backButtonTitle = "戻る"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.fetchDataFromDatabase()
    }
}

// Presenterからの描画指示
extension ChartCollectionViewController:ChartCollectionPresenterOutput{
    func setButtonLabel(orderItemLabel: String, ascDescLabel: String) {
        orderItemButton.setTitle(orderItemLabel, for: .normal)
        ascDescButton.setTitle(ascDescLabel, for: .normal)
    }
    
    func notifyDataSetChanged() {
        collectionView.reloadData()
    }
    
    func showActionSheet(alert: UIAlertController) {
        present(alert, animated: true)
    }
}

extension ChartCollectionViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(presenter.groupData.charts.count == 0){
            collectionView.setEmptyMessage("+ ボタンをタップしてチャートを作成しましょう！")
        }else{
            collectionView.restore()
        }
        return presenter.groupData.charts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(segmentView.selectedSegmentIndex == 0){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as! ChartListCell
            cell.setChartData(group: groupData, chartObject: presenter.chartList[indexPath.row] )
            setTapRecognizer(radarChart: cell.chartView)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as! ChartGridCell
            cell.setChartData(group: groupData, chartObject: presenter.chartList[indexPath.row])
            setTapRecognizer(radarChart: cell.chartView)
            return cell
        }
    }
    
    private func setTapRecognizer(radarChart:UIView){
        if radarChart.gestureRecognizers?.count == 2{
            let tapAction = UITapGestureRecognizer(target: self, action: #selector(onChartTapped))
            radarChart.addGestureRecognizer(tapAction)
        }
    }
    
    
    @objc func onChartTapped(recognizer:UITapGestureRecognizer){
        let tappedLocation = recognizer.location(in: collectionView)
        let indexPath = collectionView.indexPathForItem(at: tappedLocation)
        if indexPath == nil{
            return
        }
        tappedIndex = indexPath!.row
        performSegue(withIdentifier: "toChartCreateViewControllerPush", sender: nil)
    }
}

extension ChartCollectionViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tappedIndex = indexPath.row
        performSegue(withIdentifier: "toChartCreateViewControllerPush", sender: nil)
    }
}
