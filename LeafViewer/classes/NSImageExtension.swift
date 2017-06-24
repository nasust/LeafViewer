//
// Created by hideki on 2017/06/21.
// Copyright (c) 2017 hideki. All rights reserved.
//

import Foundation
import Cocoa

extension NSImage {

    func isAnimationGif() -> Bool{
        let reps = self.representations
        for rep in reps {
            if let bitmapRep : NSBitmapImageRep = rep as? NSBitmapImageRep {
                let numFrame = bitmapRep.value(forProperty: NSImageFrameCount) as! Int
                return numFrame > 1
            }
        }
        return false
    }

}

