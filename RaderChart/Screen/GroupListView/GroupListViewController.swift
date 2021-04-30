//
//  ViewController.swift
//  RaderChart
//
//  Created by aoshima on 2021/04/09.
//  Copyright © 2021 aoshima. All rights reserved.
//

import UIKit

class GroupListViewController: UIViewController {
    
    private var presenter:GroupListPresenterInput!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = GroupListPresenter(view: self)
        presenter.viewDidLoad()
        
        self.navigationItem.title = "グループ"
        tableView.register(UINib(nibName: "GroupListCell", bundle: nil), forCellReuseIdentifier: "customCell")
    }
}

extension GroupListViewController:GroupListPresenterOutput{
    func showGroupList() {
        print("リストにデータを表示します")
        print(presenter.dataList.description)
    }
}

extension GroupListViewController:UITableViewDelegate{

}

extension GroupListViewController:UITableViewDataSource{
    // セルを返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! GroupListCell
        cell.titleView.text = "タイトル\(indexPath)"
        return cell
    }
    
    // セルの数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}
