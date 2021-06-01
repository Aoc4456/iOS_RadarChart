//
//  GroupSortPresenter.swift
//  RadarChart
//
//  Created by M Aoshima on 2021/06/01.
//  Copyright © 2021 aoshima. All rights reserved.
//

import Foundation

class GroupSortPresenter:GroupSortPresenterInput{
    
    private weak var view:GroupSortPresenterOutput!
    
    init(view:GroupSortPresenterOutput) {
        self.view = view
    }
    
}


// Presenterが実装するプロトコル
// Viewから呼び出されるインターフェースを定義する
protocol GroupSortPresenterInput{
    
}


// ViewControllerが実装するプロトコル
// Presenterから呼び出されるインターフェースを定義する
protocol GroupSortPresenterOutput:AnyObject {
    
}
