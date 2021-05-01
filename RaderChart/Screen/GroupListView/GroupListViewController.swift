//
//  ViewController.swift
//  RaderChart
//
//  Created by aoshima on 2021/04/09.
//  Copyright © 2021 aoshima. All rights reserved.
//

import UIKit
import Charts

class GroupListViewController: UIViewController {
    
    private var presenter:GroupListPresenterInput!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = GroupListPresenter(view: self)
        presenter.fetchDataFromDatabase()
        
        self.navigationItem.title = "グループ"
        tableView.register(UINib(nibName: "GroupListCell", bundle: nil), forCellReuseIdentifier: "customCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.fetchDataFromDatabase()
    }
}

extension GroupListViewController:GroupListPresenterOutput{
    func reloadTableView() {
        tableView.reloadData()
    }
}

extension GroupListViewController:UITableViewDelegate{

}

extension GroupListViewController:UITableViewDataSource{
    // セルを返す　ここでデータを参照してビューに反映する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! GroupListCell
        let data = presenter.dataList[indexPath.row]
        cell.titleView.text = "\(data.title) : \(data.labels.count)"
        cell.subTitleView.text = "作成日：\(data.createdAt)"
        
        let chartColor = ColorUtil.convertStringToColor(colorString: data.color)
        let chartData = MyChartUtil.getSampleChartData(color: chartColor, numberOfItems: data.labels.count)
        cell.radarChart.data = chartData
        
        return cell
    }
    
    // セルの数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.dataList.count
    }
}
