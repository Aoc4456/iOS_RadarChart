//
//  GroupListCell.swift
//  RadarChart
//
//  Created by M Aoshima on 2021/04/10.
//  Copyright © 2021 aoshima. All rights reserved.
//

import UIKit

class GroupListCell: UITableViewCell {
    
    @IBOutlet weak var radarChart: ChartForGroupList!
    
    @IBOutlet weak var titleView: UILabel!
    
    @IBOutlet weak var labelChartsCount: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconImageView.contentMode = .scaleAspectFit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(group:ChartGroup,vc:UIViewController,icon:UIImage?){
        titleView.text = group.title
        labelChartsCount.text = group.charts.count.description
        
        if(icon == nil){
            // チャートを表示する
            iconImageView.isHidden = true
            radarChart.isHidden = false
            if radarChart.gestureRecognizers?.count == 2{ // もともと２つのgestureRecognizerが登録されている
                let tapAction = UITapGestureRecognizer(target: vc, action: #selector(GroupListViewController.onChartTapped))
                radarChart.addGestureRecognizer(tapAction)
            }
            
            let chartColor = group.color.toUIColor()
            let chartData = MyChartUtil.getSampleChartData(color: chartColor, numberOfItems: group.labels.count)
            radarChart.data = chartData
            
        }else{
            // アイコンを表示する
            iconImageView.isHidden = false
            radarChart.isHidden = true
            if iconImageView.gestureRecognizers?.count == 0{ 
                let tapAction = UITapGestureRecognizer(target: vc, action: #selector(GroupListViewController.onChartTapped))
                iconImageView.addGestureRecognizer(tapAction)
            }
            iconImageView.image = icon!
        }
    }
}
