//
// Created by hideki on 2017/06/22.
// Copyright (c) 2017 hideki. All rights reserved.
//

import Foundation
import AppKit

class ImageScrollView : NSScrollView{
    
    var scrollWheelEventClosure : ((NSEvent) -> Void)?

    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func scrollWheel(with event: NSEvent) {
        if self.frame.width >= self.documentView!.frame.width && self.frame.height >= self.documentView!.frame.height{
            scrollWheelEventClosure!(event)
        }else{
            super.scrollWheel(with: event)
        }
    }


    
}
