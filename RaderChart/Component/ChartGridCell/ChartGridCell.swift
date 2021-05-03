//
//  ChartGridCell.swift
//  RaderChart
//
//  Created by M Aoshima on 2021/05/03.
//  Copyright © 2021 aoshima. All rights reserved.
//

import UIKit

class ChartGridCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

func getChartGridCellFlowLayout(view:UIView) -> UICollectionViewFlowLayout {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: view.frame.width / 3.1, height: view.frame.width / 3.1)
    return layout
}
