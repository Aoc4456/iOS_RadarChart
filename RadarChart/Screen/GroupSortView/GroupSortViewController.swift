//
//  GroupSortViewController.swift
//  RadarChart
//
//  Created by M Aoshima on 2021/06/01.
//  Copyright © 2021 aoshima. All rights reserved.
//

import UIKit

class GroupSortViewController: UIViewController {
    
    private var presenter:GroupSortPresenterInput!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.presenter = GroupSortPresenter(view: self)

        let leftButton = UIBarButtonItem(title: "閉じる", style: UIBarButtonItem.Style.plain, target: self, action: #selector(onTapCloseButton(_:)))
        self.navigationItem.leftBarButtonItem = leftButton
    }
    

    @objc func onTapCloseButton(_ sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }

}

extension GroupSortViewController:GroupSortPresenterOutput{
    
}
