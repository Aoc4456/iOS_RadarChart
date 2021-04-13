//
//  GroupCreateViewController.swift
//  RaderChart
//
//  Created by M Aoshima on 2021/04/11.
//  Copyright © 2021 aoshima. All rights reserved.
//

import UIKit

class GroupCreateViewController: UIViewController {
    
    private var selectedColor = UIColor.systemTeal
    private var colorPicker = UIColorPickerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "グループ作成"
        let leftButton = UIBarButtonItem(title: "閉じる", style: UIBarButtonItem.Style.plain, target: self, action: #selector(onTapCloseButton(_:)))
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func onTapCloseButton(_ sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }

}
