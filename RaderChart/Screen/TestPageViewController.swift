//
//  TestPageViewController.swift
//  RaderChart
//
//  Created by aoshima on 2021/04/14.
//  Copyright © 2021 aoshima. All rights reserved.
//

import UIKit
import Charts

class TestPageViewController: UIViewController {

    @IBOutlet weak var raderChart: RadarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "テスト用ページ"
        setupChart()
    }
    
    private func setupChart(){
        let greenDataSet = RadarChartDataSet(
            entries: [
                RadarChartDataEntry(value: 210),
                RadarChartDataEntry(value: 60.0),
                RadarChartDataEntry(value: 150.0),
                RadarChartDataEntry(value: 150.0),
                RadarChartDataEntry(value: 160.0),
                RadarChartDataEntry(value: 150.0),
                RadarChartDataEntry(value: 110.0),
                RadarChartDataEntry(value: 190.0),
                RadarChartDataEntry(value: 200.0)
            ]
        )
        
        /*
         * 個別のチャートの設定
         */
        // 線の太さ
        greenDataSet.lineWidth = 3
        // 線の色
        greenDataSet.colors = [UIColor.green]
        // 塗りつぶしの色
        greenDataSet.fillColor = UIColor.green
        greenDataSet.drawFilledEnabled = true
        greenDataSet.valueFormatter = TestDataSetValueFormatter()
        
        /*
         * チャートグループの設定
         * 中心から外に向かう線    = x軸 (xAxis)
         * ウェブ同士を結ぶ内側の線 = y軸 (yAxis)
         */
        // 中心から外に向かう線の太さ (デフォルト = 1.5)
        raderChart.webLineWidth = 3
        // 中心から外に向かう線の色
        raderChart.webColor = UIColor.green
        // 内側の線の太さ (デフォルト = 0.75)
        raderChart.innerWebLineWidth = 2
        // 内側の線の色
        raderChart.innerWebColor = UIColor.green
        // 回転を許すか
        raderChart.rotationEnabled = false
        // 凡例表示
        raderChart.legend.enabled = true
        // タップして強調表示する機能をOFF
        raderChart.highlightPerTapEnabled = false
        
        /*
         * x軸 (中心から外に向かう線) の設定
         */
        let xAxis = raderChart.xAxis
        // xAxis.label = グラフの外側に表示される項目名
        xAxis.labelFont = .systemFont(ofSize: 15,weight: .bold)
        xAxis.labelTextColor = .black
        xAxis.xOffset = 20 // TODO ラベルとの距離が設定できるはずだが、できない
        xAxis.yOffset = 20
        xAxis.valueFormatter = TestXAxisFormatter()
        
        /*
         * y軸 (ウェブ同士を繋ぐ線)の設定
         */
        let yAxis = raderChart.yAxis
        yAxis.labelFont = .systemFont(ofSize: 10,weight: .light)
        // 分割数
        yAxis.labelCount = 6
        // y軸の値を非表示にする (最大値と最小値のラベルのみ非表示にすることも可)
        yAxis.drawTopYLabelEntryEnabled = false
        yAxis.drawBottomYLabelEntryEnabled = false
        // グラフの原点を、値のうち最小のものではなく0にする
        yAxis.axisMinimum = 0
        
        let data = RadarChartData(dataSets: [greenDataSet])
        raderChart.data = data
    }
}

class TestXAxisFormatter:IAxisValueFormatter{
    let titles = "ABCDEFGHI".map { "Party \($0)" }
       
       func stringForValue(_ value: Double, axis: AxisBase?) -> String {
           titles[Int(value) % titles.count]
       }
}

// RaderChartDataSetにセットするFormatter
// 各項目の最終的な値を表示しないようにするため、""を返す
class TestDataSetValueFormatter:IValueFormatter{
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return ""
    }
}
