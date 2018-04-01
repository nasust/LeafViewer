//
// Created by hideki on 2017/06/22.
// Copyright (c) 2017 hideki. All rights reserved.
//

import Foundation
import Cocoa

class ReduceDisplayLargerScreenCalculationViewSize: CalculationViewSize {
    static func calculateTargetImageSize(window: NSWindow, image: NSImage) -> NSSize {
        NSLog("ReduceDisplayLargerScreenCalculationViewSize")

        var targetSize = NSMakeSize(0, 0)

        let windowVisibleFrame = NSScreen.main!.visibleFrame;
        //todo current screen

        let headerHeight = window.toolbar!.isVisible ? CGFloat(56) : CGFloat(22)

        if windowVisibleFrame.width < image.size.width || windowVisibleFrame.height < image.size.height + headerHeight{

            targetSize = AutomaticZoomCalculationViewSize.calculateTargetImageSize(window: window, image: image)

        } else {
            targetSize = image.size
        }

        return targetSize
    }
}
