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
        otherStackView.addArrangedSubview(createAppStoreListTile())
        otherStackView.addArrangedSubview(createVersionNameListTile())
    }
    
    @objc func onTapCloseButton(_ sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    // プライバシーポリシー
    private func createPrivacyPolicyListTile() -> ListTile{
        let listTile = ListTile()
        let image = UIImage(systemName: "person")
        listTile.setData(image: image!, title: "プライバシーポリシー", callBack: {
            self.performSegue(withIdentifier: "toPrivacyPolicyViewController", sender: nil)
        })
        return listTile
    }
    
    // App Store　への遷移
    private func createAppStoreListTile() -> ListTile{
        let listTile = ListTile()
        let image = UIImage(systemName: "rectangle.and.pencil.and.ellipsis")
        listTile.setData(image: image!, title: "このアプリをレビューする", callBack: {
            let url = NSURL(string:"https://apps.apple.com/jp/app/%E3%83%AC%E3%83%BC%E3%83%80%E3%83%BC%E3%83%81%E3%83%A3%E3%83%BC%E3%83%88%E3%83%A1%E3%83%BC%E3%82%AB%E3%83%BC/id1571022856")
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        })
        return listTile
    }
    
    // バージョン番号
    private func createVersionNameListTile() -> SubTitleListTile{
        let listTile = SubTitleListTile()
        let image = UIImage(systemName: "info.circle")
        let version: String! = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        listTile.setData(image: image!, title: "アプリのバージョン", subTitle: version, callBack: nil)
        return listTile
    }
}
