//
//  LabelSortViewController.swift
//  RadarChart
//
//  Created by M Aoshima on 2021/06/19.
//  Copyright © 2021 aoshima. All rights reserved.
//

import UIKit

class LabelSortViewController: UIViewController {
    
    private var presenter:LabelSortPresenterInput!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup presenter
        self.presenter = LabelSortPresenter(view: self)

        let leftButton = UIBarButtonItem(title: "閉じる", style: UIBarButtonItem.Style.plain, target: self, action: #selector(onTapCloseButton(_:)))
        self.navigationItem.leftBarButtonItem = leftButton
    }
    

    @objc func onTapCloseButton(_ sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
}

extension LabelSortViewController:LabelSortPresenterOutput{
    
}
