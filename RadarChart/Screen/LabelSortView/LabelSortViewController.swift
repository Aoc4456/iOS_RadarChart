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
    @IBOutlet weak var chartView: ChartForItemSortScreen!
    @IBOutlet weak var tableView: UITableView!
    
    var passedData:ChartGroup!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("もらいました\(passedData.description)")
        
        // setup presenter
        self.presenter = LabelSortPresenter(view: self)
        presenter.viewDidLoad(passedData: passedData)

        let leftButton = UIBarButtonItem(title: "閉じる", style: UIBarButtonItem.Style.plain, target: self, action: #selector(onTapCloseButton(_:)))
        self.navigationItem.leftBarButtonItem = leftButton
        
        // setup tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60
        
        // 並び替え
        tableView.setEditing(true, animated: true)
    }
    

    @objc func onTapCloseButton(_ sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
}

extension LabelSortViewController:LabelSortPresenterOutput{
    func setChartDataSource() {
        chartView.data = presenter.radarChartData
        notifyChartDataChanged()
    }
    
    func notifyChartDataChanged() {
        (chartView.xAxis.valueFormatter as! RowXAxisFormatter).setLabel(labels: presenter.chartLabels)
        chartView.data?.notifyDataChanged()
        chartView.notifyDataSetChanged()
    }
}

extension LabelSortViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.groupData.labels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "labelSortCell", for: indexPath)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = presenter.chartLabels[indexPath.row]
        cell.showsReorderControl = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        presenter.reorderData(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}

extension LabelSortViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
