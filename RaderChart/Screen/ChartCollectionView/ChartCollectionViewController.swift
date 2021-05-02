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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup Presenter
        self.presenter = ChartCollectionPresenter(view: self)
        
        presenter.viewDidLoad()
    }

}

extension ChartCollectionViewController:ChartCollectionPresenterOutput{
    
}
