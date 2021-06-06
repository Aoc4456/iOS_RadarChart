//
//  MyUserDefaults.swift
//  RadarChart
//
//  Created by M Aoshima on 2021/05/26.
//  Copyright © 2021 aoshima. All rights reserved.
//

import Foundation

// リスト表示　or　グリッド表示
let keySegmentIndex = "segmentIndex"

func saveSegmentIndex(index:Int){
    UserDefaults.standard.set(index, forKey: keySegmentIndex)
}

func loadSegmentIndex() -> Int{
    UserDefaults.standard.integer(forKey: keySegmentIndex)
}

// アプリ起動回数
let keyAppLaunchCount = "AppLaunchCount"

func loadAppLaunchCount() -> Int{
    UserDefaults.standard.integer(forKey: keyAppLaunchCount)
}

func incrementAppLaunchCount(){
    let preCount = loadAppLaunchCount()
    UserDefaults.standard.set(preCount + 1,forKey: keyAppLaunchCount)
}

func resetAppLaunchCount(){
    UserDefaults.standard.set(0,forKey: keyAppLaunchCount)
}
