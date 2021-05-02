//
//  ChartListCell.swift
//  RaderChart
//
//  Created by M Aoshima on 2021/05/02.
//  Copyright © 2021 aoshima. All rights reserved.
//

import UIKit

class ChartListCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

func getChartListCellFlowLayout(view:UICollectionView) -> UICollectionViewFlowLayout {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: view.frame.width, height: 150)
    return layout
}
