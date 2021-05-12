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
    
    func setChartData(group:ChartGroup,index:Int){
        chartView.setData(group: group, index: index)
    }
}

func getChartListCellFlowLayout(view:UIView) -> UICollectionViewFlowLayout {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: view.frame.width - 20, height: 150)
    return layout
}
