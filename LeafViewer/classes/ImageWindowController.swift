//
// Created by hideki on 2017/06/19.
// Copyright (c) 2017 hideki. All rights reserved.
//

import Foundation
import Cocoa

class ImageWindowController: NSWindowController {

    @IBOutlet weak var imageToolBar: NSToolbar!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func loadWindow() {
        super.loadWindow()
    }

    override func windowWillLoad() {
        super.windowWillLoad()


    }

    override func windowDidLoad() {
        super.windowDidLoad()

        let controller = self.contentViewController as! ImageViewController
        controller.window = self.window
        controller.scrollWheelEventClosure = { event -> Void in
            self.contentsScrollWheel(with: event)
        }

        DispatchQueue.main.async { //少しだけ遅らせないとToolBarのvisibleの判定が変になる
            self.refreshImage()
        }
    }

    override func scrollWheel(with event: NSEvent) {
        //tool bar scroll
        self.changeImage(event: event)
    }

    func contentsScrollWheel(with event: NSEvent) {
        //contents scroll
        self.changeImage(event: event)
    }

    private var changeTime = NSDate()

    func changeImage(event: NSEvent) {
        if (event.deltaY <= -1.0) {
            let currentDate = NSDate()
            if ((currentDate.timeIntervalSince1970 - changeTime.timeIntervalSince1970) > 0.2) {
                if self.nextImage() {
                    self.changeTime = NSDate()
                }
            }
        } else if (event.deltaY >= 1.0) {
            let currentDate = NSDate()
            if ((currentDate.timeIntervalSince1970 - changeTime.timeIntervalSince1970) > 0.2) {
                if self.prevImage() {
                    self.changeTime = NSDate()
                }
            }
        }
    }

    func refreshImage() {
        let controller = self.contentViewController as! ImageViewController
        controller.refreshImage()

        if self.window!.styleMask.contains(.fullScreen) {
            return
        }

        let windowFrame = self.window!.frame
        let headerHeight = self.window!.toolbar!.isVisible ? CGFloat(56) : CGFloat(22)

        NSLog("header height window : %f", headerHeight)

        var width = windowFrame.size.width
        var height = windowFrame.size.height

        let windowVisibleFrame = NSScreen.main()!.visibleFrame;

        if App.configViewMode == ViewMode.automaticZoom {
            width = controller.imageView!.frame.width
            height = controller.imageView!.frame.height + headerHeight

        } else if App.configViewMode == ViewMode.original || App.configViewMode == ViewMode.reduceDisplayLargerScreen {
            if windowVisibleFrame.width > controller.imageView!.frame.width {
                width = controller.imageView!.frame.width
            } else {
                width = windowVisibleFrame.width
            }
            if windowVisibleFrame.height > controller.imageView!.frame.height {
                height = controller.imageView!.frame.height + headerHeight
            } else {
                height = windowVisibleFrame.height
            }
        }

        let x: CGFloat = windowFrame.origin.x
        let y: CGFloat = windowFrame.origin.y

        self.window!.setFrame(NSMakeRect(x, y, width, height), display: true, animate: false)

        self.window!.title = NSString(string: ImageFileManager.shared.currentImageFileName!).lastPathComponent
                + " " + String(ImageFileManager.shared.currentIndex + 1) + "/" + String(ImageFileManager.shared.totalCount);

        if App.configIsCenterWindow {
            self.window!.center()
        }


    }

    @IBAction func toolBarNext(_ sender: Any) {
        _ = self.nextImage()
    }

    @IBAction func toolBarPrev(_ sender: Any) {
        _ = self.prevImage()
    }

    func nextImage() -> Bool {

        if (ImageFileManager.shared.hasNext()) {
            if (ImageFileManager.shared.doNext()) {
                self.refreshImage()
                return true
            }
        } else if ImageFileManager.shared.doFirst() {
            self.refreshImage()
            return true
        }

        return false
    }

    func prevImage() -> Bool {
        if (ImageFileManager.shared.hasPrev()) {
            if (ImageFileManager.shared.doPrev()) {
                self.refreshImage()
                return true
            }
        } else if ImageFileManager.shared.doLast() {
            self.refreshImage()
            return true
        }
        return false
    }

    func firstImage() -> Bool {
        if ImageFileManager.shared.doFirst() {
            self.refreshImage()
            return true
        }

        return false
    }

    func lastImage() -> Bool {
        if ImageFileManager.shared.doLast() {
            self.refreshImage()
            return true
        }
        return false
    }

    func originalImageSize() {
        let controller = self.contentViewController as! ImageViewController
        controller.refreshImage(viewMode: ViewMode.original)
    }

    func zoomImageSize() {
        let controller = self.contentViewController as! ImageViewController
        controller.zoomImageSize()
    }

    func smallImageSize() {
        let controller = self.contentViewController as! ImageViewController
        controller.smallImageSize()
    }

    @IBAction func toolBarZoom(_ sender: Any) {
        self.zoomImageSize()
    }

    @IBAction func toolBarSmall(_ sender: Any) {
        self.smallImageSize()
    }


}
