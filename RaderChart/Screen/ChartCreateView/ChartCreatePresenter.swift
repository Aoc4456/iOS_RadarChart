//
//  ChartCreatePresenter.swift
//  RaderChart
//
//  Created by M Aoshima on 2021/05/03.
//  Copyright © 2021 aoshima. All rights reserved.
//

import Foundation

class ChartCreatePresenter:ChartCreatePresenterInput{
    
    private weak var view:ChartCreatePresenterOutput!
    
    init(view:ChartCreatePresenterOutput) {
        self.view = view
    }
    
    func viewDidLoad() {
        print("チャート作成画面のPresenterです")
    }
}

// Presenterが実装するプロトコル
// Viewから呼び出されるインターフェースを定義する
protocol ChartCreatePresenterInput {
    func viewDidLoad()
}

// ViewControllerが実装するプロトコル
// Presenterから呼び出されるインターフェースを定義する
protocol ChartCreatePresenterOutput:AnyObject {
    
}
