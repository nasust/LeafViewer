//
// Created by hideki on 2017/06/22.
// Copyright (c) 2017 hideki. All rights reserved.
//

import Foundation
import Cocoa

class AutomaticZoomCalculationViewSize : CalculationViewSize {
    static func calculateTargetImageSize(window: NSWindow, image: NSImage) -> NSSize{

        let margin: CGFloat = window.styleMask.contains(.fullScreen) ? 0 : 30
        var targetSize = NSMakeSize(0, 0)

        let windowVisibleFrame = NSScreen.main()!.visibleFrame;
        //todo current screen

        var headerHeight = window.frame.size.height - window.contentView!.frame.size.height
        if window.styleMask.contains(.fullScreen) && window.toolbar!.isVisible {
            headerHeight = 35
        }

        NSLog("header height: %f", headerHeight)

        var targetImageViewWidth: CGFloat = image.size.width
        var targetImageViewHeight: CGFloat = image.size.height

        if image.size.width > (image.size.height + headerHeight) {

            let coefficient = windowVisibleFrame.size.width / image.size.width
            targetImageViewWidth = image.size.width * coefficient
            targetImageViewHeight = image.size.height * coefficient

            if targetImageViewHeight + headerHeight + margin > windowVisibleFrame.size.height {
                let contentHeight = (windowVisibleFrame.size.height - headerHeight - margin)
                let coefficient = contentHeight / targetImageViewHeight

                targetImageViewWidth = targetImageViewWidth * coefficient
                targetImageViewHeight = targetImageViewHeight * coefficient
            }

        } else {
            let contentHeight = (windowVisibleFrame.size.height - headerHeight - margin)
            let coefficient = contentHeight / image.size.height

            NSLog("contentHeight: %f" , contentHeight )

            targetImageViewWidth = image.size.width * coefficient
            targetImageViewHeight = image.size.height * coefficient


            if targetImageViewWidth > windowVisibleFrame.size.width {
                let coefficient = windowVisibleFrame.size.width / targetImageViewWidth
                targetImageViewWidth = targetImageViewWidth * coefficient
                targetImageViewHeight = targetImageViewHeight * coefficient
            }

        }

        targetSize.width = targetImageViewWidth
        targetSize.height = targetImageViewHeight

        NSLog("targetSize: %f , %f" , targetSize.width , targetSize.height)

        return targetSize
    }
}
