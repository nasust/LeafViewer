//
// Created by hideki on 2017/06/22.
// Copyright (c) 2017 hideki. All rights reserved.
//

import Foundation
import Cocoa

class ImageCalculationViewSize {
    static func calculateTargetImageSize(viewMode: ViewMode, window: NSWindow, image: NSImage) -> NSSize {
        switch viewMode {
        case .reduceDisplayLargerScreen:
            return ReduceDisplayLargerScreenCalculationViewSize.calculateTargetImageSize(window: window, image: image)
        case .automaticZoom:
            return AutomaticZoomCalculationViewSize.calculateTargetImageSize(window: window, image: image)
        case .justWindow:
            return JustWindowCalculationViewSize.calculateTargetImageSize(window: window, image: image)
        default:
            return OriginalCalculationViewSize.calculateTargetImageSize(window: window, image: image)
        }
    }
}
