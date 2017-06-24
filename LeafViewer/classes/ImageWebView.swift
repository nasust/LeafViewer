//
// Created by hideki on 2017/06/21.
// Copyright (c) 2017 hideki. All rights reserved.
//

import Foundation
import WebKit

class ImageWebView : WKWebView{

    var scrollWheelEventClosure : ((NSEvent) -> Void)?

    override func willOpenMenu(_ menu: NSMenu, with event: NSEvent) {
        for menuItem in menu.items{
            menuItem.isHidden = true
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        return false
    }

    override func scrollWheel(with event: NSEvent) {
        self.scrollWheelEventClosure!(event)
    }

    
}
