//
//  GroupSortCell.swift
//  RadarChart
//
//  Created by M Aoshima on 2021/06/01.
//  Copyright © 2021 aoshima. All rights reserved.
//

import UIKit

class GroupSortCell: UITableViewCell {

    @IBOutlet weak var myChart: ChartForGroupList!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var sortLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(group:ChartGroup,icon:UIImage?){
        titleLabel.text = group.title
        sortLabel.text = group.rate.description
        
        if(icon == nil){
            // チャートを表示する
            iconImageView.isHidden = true
            myChart.isHidden = false
            let chartColor = group.color.toUIColor()
            let chartData = MyChartUtil.getSampleChartData(color: chartColor, numberOfItems: group.labels.count)
            myChart.data = chartData
        }else{
            // アイコンを表示する
            iconImageView.isHidden = false
            myChart.isHidden = true
            iconImageView.image = icon!
        }
    }
}
