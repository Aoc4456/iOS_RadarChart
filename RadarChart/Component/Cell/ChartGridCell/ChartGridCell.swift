//
//  ChartGridCell.swift
//  RadarChart
//
//  Created by M Aoshima on 2021/05/03.
//  Copyright © 2021 aoshima. All rights reserved.
//

import UIKit

class ChartGridCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleView: UILabel!
    @IBOutlet weak var chartView: ChartForCollectionView!
    @IBOutlet weak var sortValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.borderColor = UIColor.gray.cgColor
        containerView.layer.borderWidth = 0.3
        containerView.layer.cornerRadius = 15
        containerView.layer.masksToBounds = false
    }
    
    func setChartData(group:ChartGroup,chartObject:MyChartObject){
        titleView.text = chartObject.title
        sortValueLabel.text = getSortedValue(group: group, chartObject: chartObject)
        chartView.setData(group: group, chartObject: chartObject,labelSize: .Small)
    }
    
    private func getSortedValue(group:ChartGroup,chartObject:MyChartObject) -> String{
        var labelText = ""
        switch group.sortedIndex {
        case -3: // 合計
            labelText = Int(chartObject.values.sum()).description
        case -2: // 更新日
            labelText = chartObject.updatedAt.toLocaleDateStringShort()
        case -1: // 作成日
            labelText = chartObject.createdAt.toLocaleDateStringShort()
        default:
            labelText = Int(chartObject.values[group.sortedIndex]).description
        }
        return labelText
    }
}

func getChartGridCellFlowLayout(view:UIView) -> UICollectionViewFlowLayout {
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = 0
    
    let mainBoundWidth: CGFloat = UIScreen.main.bounds.size.width
    // iPhone8 Plusが414  iPadMiniが768
    if(mainBoundWidth < 410){
        layout.itemSize = CGSize(width: view.bounds.width / 2.1, height: view.bounds.width / 2.1)
    }else{
        layout.itemSize = CGSize(width: view.bounds.width / 3.1, height: view.bounds.width / 3.1)
    }
    
    return layout
}
