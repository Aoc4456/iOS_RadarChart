//
//  ChartCollectionViewController.swift
//  RaderChart
//
//  Created by M Aoshima on 2021/05/02.
//  Copyright © 2021 aoshima. All rights reserved.
//

import UIKit

class ChartCollectionViewController: UIViewController {
    
    private var presenter:ChartCollectionPresenterInput!
    var passedData : ChartGroup!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentView: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = passedData.title
        
        // setup Presenter
        self.presenter = ChartCollectionPresenter(view: self)
        
        
        // setup CollectionView
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ChartListCell", bundle: nil), forCellWithReuseIdentifier: "ListCell")
        collectionView.register(UINib(nibName: "ChartGridCell", bundle: nil), forCellWithReuseIdentifier: "GridCell")
        
        // setup CollectionViewCell
        collectionView.collectionViewLayout = getChartListCellFlowLayout(view: collectionView)
        
        presenter.viewDidLoad()
    }

    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0:
            // 現在のレイアウトを無効にし、レイアウトの更新をトリガーします
            collectionView.reloadData()
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.setCollectionViewLayout(getChartListCellFlowLayout(view: collectionView), animated: true)
            break
        case 1:
            collectionView.reloadData()
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.setCollectionViewLayout(getChartGridCellFlowLayout(view: collectionView), animated: true)
            break
        default:
            break
        }
    }
}

// Presenterからの描画指示
extension ChartCollectionViewController:ChartCollectionPresenterOutput{
    
}

extension ChartCollectionViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(segmentView.selectedSegmentIndex == 0){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as! ChartListCell
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as! ChartGridCell
            return cell
        }
    }
}
