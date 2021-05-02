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

func getChartGridCellFlowLayout(view:UICollectionView) -> UICollectionViewFlowLayout {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: view.frame.width / 2.1, height: 150)
    return layout
}
