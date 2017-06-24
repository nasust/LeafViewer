//
// Created by hideki on 2017/06/22.
// Copyright (c) 2017 hideki. All rights reserved.
//

import Foundation

enum ViewMode: Int {
    case original //実寸表示
    case automaticZoom //常に画面に合わせて拡大
    case justWindow //常にウィンドウに合わせる
    case reduceDisplayLargerScreen //画面より大きい場合、縮小する
}

