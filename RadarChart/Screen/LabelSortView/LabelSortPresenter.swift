//
//  LabelSortPresenter.swift
//  RadarChart
//
//  Created by M Aoshima on 2021/06/19.
//  Copyright © 2021 aoshima. All rights reserved.
//

import Foundation

class LabelSortPresenter : LabelSortPresenterInput{
    
    private weak var view:LabelSortPresenterOutput!
    
    init(view:LabelSortPresenterOutput) {
        self.view = view
    }
}

// Presenterが実装するプロトコル
// Viewから呼び出されるインターフェースを定義する
protocol LabelSortPresenterInput{

}

// ViewControllerが実装するプロトコル
// Presenterから呼び出されるインターフェースを定義する
protocol LabelSortPresenterOutput:AnyObject {

}
