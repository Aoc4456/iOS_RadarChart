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
    
    let mainBoundWidth: CGFloat = UIScreen.main.bounds.size.width
    // iPhone8 Plusが414  iPadMiniが768
    if(mainBoundWidth < 700){
        layout.itemSize = CGSize(width: view.bounds.width / 2.1, height: view.bounds.width / 2.1)
    }else{
        layout.itemSize = CGSize(width: view.bounds.width / 3.1, height: view.bounds.width / 3.1)
    }
    
    return layout
}
