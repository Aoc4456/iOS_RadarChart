//
//  SettingViewController.swift
//  RadarChart
//
//  Created by aoshima on 2021/05/26.
//  Copyright © 2021 aoshima. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var otherStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setup navigation item
        self.navigationItem.title = "設定"
        let leftButton = UIBarButtonItem(title: "閉じる", style: UIBarButtonItem.Style.plain, target: self, action: #selector(onTapCloseButton(_:)))
        self.navigationItem.leftBarButtonItem = leftButton
        
        
        otherStackView.addArrangedSubview(createPrivacyPolicyListTile())
        otherStackView.addArrangedSubview(createVersionNameListTile())
        
    }
    
    @objc func onTapCloseButton(_ sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }

    private func createPrivacyPolicyListTile() -> ListTile{
        let listTile = ListTile()
        let image = UIImage(systemName: "person")
        listTile.setData(image: image!, title: "プライバシーポリシー", callBack: {
            self.performSegue(withIdentifier: "toPrivacyPolicyViewController", sender: nil)
        })
        return listTile
    }
    
    private func createVersionNameListTile() -> SubTitleListTile{
        let listTile = SubTitleListTile()
        let image = UIImage(systemName: "info.circle")
        let version: String! = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        listTile.setData(image: image!, title: "アプリのバージョン", subTitle: version, callBack: nil)
        return listTile
    }
}
