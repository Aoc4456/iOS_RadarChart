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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = passedData.title
        
        // setup Presenter
        self.presenter = ChartCollectionPresenter(view: self)
        
        presenter.viewDidLoad()
    }

}

// Presenterからの描画指示
extension ChartCollectionViewController:ChartCollectionPresenterOutput{
    
}
