//
// Created by hideki on 2017/06/22.
// Copyright (c) 2017 hideki. All rights reserved.
//

import Foundation
import Cocoa

class JustWindowCalculationViewSize: CalculationViewSize {
    static func calculateTargetImageSize(window: NSWindow, image: NSImage) -> NSSize {

        var targetSize = NSMakeSize(0, 0)

        NSLog("just window: %f ,%f", window.frame.width, window.frame.height)

        let contentRect = window.contentRect(forFrameRect: window.frame)

        if image.size.width > image.size.height {

            targetSize.width = contentRect.size.width
            let coefficient = contentRect.size.width / image.size.width
            targetSize.height = image.size.height * coefficient

            if targetSize.height > contentRect.height {
                let coefficient = contentRect.height / targetSize.height

                targetSize.width = targetSize.width * coefficient
                targetSize.height = targetSize.height * coefficient
            }

        } else {

            targetSize.height = contentRect.size.height
            let coefficient = (contentRect.size.height) / image.size.height
            targetSize.width = image.size.width * coefficient

            if targetSize.width > contentRect.width {
                let coefficient = contentRect.width / targetSize.width

                targetSize.width = targetSize.width * coefficient
                targetSize.height = targetSize.height * coefficient
            }

        }

        NSLog("just window target: %f ,%f", targetSize.width, targetSize.height)

        return targetSize
    }
}
