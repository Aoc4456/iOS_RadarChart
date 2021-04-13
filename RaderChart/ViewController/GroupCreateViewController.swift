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
    @IBOutlet weak var colorPickerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup navigation item
        self.navigationItem.title = "グループ作成"
        let leftButton = UIBarButtonItem(title: "閉じる", style: UIBarButtonItem.Style.plain, target: self, action: #selector(onTapCloseButton(_:)))
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func onTapCloseButton(_ sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapColorPickerView(_ sender: Any) {
        colorPicker.supportsAlpha = true // あとでfalseにして何が違うか確認する
        colorPicker.selectedColor = selectedColor
        colorPicker.delegate = self
        present(colorPicker, animated: true)
    }
}

// カラーピッカーdelegate
extension GroupCreateViewController: UIColorPickerViewControllerDelegate{
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        selectedColor = viewController.selectedColor
        colorPickerView.backgroundColor = selectedColor
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
    }
}
