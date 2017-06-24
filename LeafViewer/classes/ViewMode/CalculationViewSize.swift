//
// Created by hideki on 2017/06/22.
// Copyright (c) 2017 hideki. All rights reserved.
//

import Foundation
import Cocoa


protocol CalculationViewSize {
    static func calculateTargetImageSize(window: NSWindow, image: NSImage) -> NSSize
}


