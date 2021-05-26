//
//  MyUserDefaults.swift
//  RadarChart
//
//  Created by M Aoshima on 2021/05/26.
//  Copyright © 2021 aoshima. All rights reserved.
//

import Foundation

let keySegmentIndex = "segmentIndex"

func saveSegmentIndex(index:Int){
    UserDefaults.standard.set(index, forKey: keySegmentIndex)
}

func loadSegmentIndex() -> Int{
    UserDefaults.standard.integer(forKey: keySegmentIndex)
}
