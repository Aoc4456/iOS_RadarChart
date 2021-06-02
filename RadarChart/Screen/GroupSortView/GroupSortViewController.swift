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
        
        // setup tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "GroupSortCell", bundle: nil), forCellReuseIdentifier: "customCell")
        tableView.rowHeight = 80
        
        // 並び替え
        tableView.setEditing(true, animated: true)
        
        presenter.fetchDataFromDatabase()
    }
    

    @objc func onTapCloseButton(_ sender: UIBarButtonItem){
        presenter.onTapCloseButton()
    }

}

extension GroupSortViewController:GroupSortPresenterOutput{
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func dismissScreen() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension GroupSortViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! GroupSortCell
        let data = presenter.dataList[indexPath.row]
        let icon = presenter.iconImageMap[data.id]
        cell.setData(group: data,icon: icon)
        cell.showsReorderControl = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        presenter.reorderData(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}

extension GroupSortViewController:UITableViewDelegate{
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
