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
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentView: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = groupData.title
        
        // setup Presenter
        self.presenter = ChartCollectionPresenter(view: self)
        
        
        // setup CollectionView
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ChartListCell", bundle: nil), forCellWithReuseIdentifier: "ListCell")
        collectionView.register(UINib(nibName: "ChartGridCell", bundle: nil), forCellWithReuseIdentifier: "GridCell")
        
        // setup CollectionViewCell
        collectionView.collectionViewLayout = getChartListCellFlowLayout(view: containerView)
        
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // チャート作成・編集画面への遷移
        if(segue.identifier == "toChartCreateViewController"){
            let nextNaviVC = segue.destination as? UINavigationController
            let nextVC = nextNaviVC?.topViewController as? ChartCreateViewController
            nextVC?.groupData = groupData
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.fetchDataFromDatabase()
    }
}

// Presenterからの描画指示
extension ChartCollectionViewController:ChartCollectionPresenterOutput{
    func notifyDataSetChanged() {
        collectionView.reloadData()
    }
}

extension ChartCollectionViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.groupData.charts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(segmentView.selectedSegmentIndex == 0){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as! ChartListCell
            cell.setChartData(group: groupData, index: indexPath.row)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as! ChartGridCell
            cell.setChartData(group: groupData, index: indexPath.row)
            return cell
        }
    }
}
