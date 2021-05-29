//
//  PrivacyPolicyViewController.swift
//  RadarChart
//
//  Created by M Aoshima on 2021/05/29.
//  Copyright © 2021 aoshima. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class PrivacyPolicyViewController:UIViewController{
    
    @IBOutlet weak var myWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setup navigation item
        self.navigationItem.title = "プライバシーポリシー"
        
        let url = URL(string: "https://radarchart-aocm.web.app/")
        let request = URLRequest(url: url!)
        myWebView.load(request)
    }
}
