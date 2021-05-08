//
//  ChartCreateViewController.swift
//  RaderChart
//
//  Created by M Aoshima on 2021/05/03.
//  Copyright © 2021 aoshima. All rights reserved.
//

import UIKit

class ChartCreateViewController: UIViewController {
    
    private var presenter:ChartCreatePresenterInput!
    var groupData:ChartGroup!
    @IBOutlet weak var multiInputView: MultiInputField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup Navigation Item
        self.navigationItem.title = "チャート新規作成"
        let leftButton = UIBarButtonItem(title: "閉じる", style: UIBarButtonItem.Style.plain, target: self, action: #selector(onTapCloseButton(_:)))
        self.navigationItem.leftBarButtonItem = leftButton

        // setup Presenter
        self.presenter = ChartCreatePresenter(view: self)
        presenter.viewDidLoad(groupData: self.groupData)
    }
    
    @objc func onTapCloseButton(_ sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
}

extension ChartCreateViewController:ChartCreatePresenterOutput{
    func setupMultiInputView(labels: [String], axisMaximum: Int) {
        multiInputView.initialize(labels: labels, axisMaximum: axisMaximum, viewController: self)
    }
}
