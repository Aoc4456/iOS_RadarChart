//
//  ChartListCell.swift
//  RadarChart
//
//  Created by M Aoshima on 2021/05/02.
//  Copyright © 2021 aoshima. All rights reserved.
//

import UIKit

class ChartListCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var chartView: ChartForCollectionView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var commentView: UILabel!
    @IBOutlet weak var totalView: UILabel!
    @IBOutlet weak var sortValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.borderColor = UIColor.gray.cgColor
        containerView.layer.borderWidth = 0.5
        containerView.layer.cornerRadius = 15
        containerView.layer.masksToBounds = false
        
        chartView.layer.borderColor = UIColor.gray.cgColor
        chartView.layer.borderWidth = 0.5
        chartView.layer.cornerRadius = 15
        chartView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMinXMaxYCorner]
    }
    
    func setChartData(group:ChartGroup,chartObject:MyChartObject){
        titleView.text = chartObject.title
        commentView.text = chartObject.note
        
        let valueArray = Array(chartObject.values)
        let sum = valueArray.reduce(0) { $0 + $1 }
        totalView.text = "合計：\(Int(sum).description)"
        sortValueLabel.text = getSortedValue(group: group, chartObject: chartObject)
        
        chartView.setData(group: group, chartObject: chartObject,labelSize: .Medium)
    }
    
    private func getSortedValue(group:ChartGroup,chartObject:MyChartObject) -> String{
        var labelText = ""
        switch group.sortedIndex {
        case -3: // 合計
            labelText = ""
        case -2: // 更新日
            labelText = "更新日 : \(chartObject.updatedAt.toLocaleDateString())"
        case -1: // 作成日
            labelText = "作成日 : \(chartObject.createdAt.toLocaleDateString())"
        default:
            let label = group.labels[group.sortedIndex]
            labelText = "\(label) : \(Int(chartObject.values[group.sortedIndex]).description)"
        }
        return labelText
    }
}

func getChartListCellFlowLayout(view:UIView) -> UICollectionViewFlowLayout {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: view.frame.width - 20, height: 140)
    return layout
}
