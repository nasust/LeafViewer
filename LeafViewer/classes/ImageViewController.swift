//
//  ImageViewController.swift
//  LeafViewer
//
//  Created by hideki on 2017/06/19.
//  Copyright © 2017年 hideki. All rights reserved.
//

import Cocoa
import WebKit

class ImageViewController: NSViewController {

    @IBOutlet weak var scrollView: ImageScrollView!

    var imageView: NSView?
    var window: NSWindow?
    var scrollWheelEventClosure: ((NSEvent) -> Void)?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayout() {
        super.viewDidLayout()
        self.scrollView.borderType = .noBorder
        self.scrollView.scrollWheelEventClosure = { event -> Void in
            self.scrollWheelEventClosure!(event)
        }
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

    func refreshImage() {
        self.refreshImage(viewMode: App.configViewMode)
    }

    func refreshImage(viewMode: ViewMode) {

        let image = ImageFileManager.shared.currentImage!

        NSLog("image size: %f %f", image.size.width, image.size.height)

        let targetSize = ImageCalculationViewSize.calculateTargetImageSize(viewMode: viewMode, window: self.window!, image: image)
        let targetImageViewWidth = targetSize.width
        let targetImageViewHeight = targetSize.height

        if NSString(string: ImageFileManager.shared.currentImageFileName!).pathExtension.caseInsensitiveCompare("gif") == .orderedSame
                   && image.isAnimationGif() == true {
            let webConfiguration = WKWebViewConfiguration()
            let webView = ImageWebView(frame: NSMakeRect(0, 0, floor(targetImageViewWidth), floor(targetImageViewHeight)), configuration: webConfiguration)
            let gifData = NSData(contentsOfFile: ImageFileManager.shared.currentImageFileName!)

            //手抜きアニメーションGIF実装
            let htmlString = "<body style='margin:0px;padding:0px'><img src='data:image/gif;base64," + gifData!.base64EncodedString() + "' width='100%' height='100%' style=`margin:0px;padding:0px;`></body>"

            webView.loadHTMLString(htmlString, baseURL: NSURL() as URL)
            webView.scrollWheelEventClosure = { event -> Void in
                self.scrollWheelEventClosure!(event)
            }

            self.imageView = webView

        } else {
            self.imageView = NSImageView(image: self.imageResize(srcImage: image, newSize: NSMakeSize(floor(targetImageViewWidth), floor(targetImageViewHeight))))
            self.imageView!.setFrameSize(NSMakeSize(floor(targetImageViewWidth), floor(targetImageViewHeight)))
        }

        self.scrollView.documentView = imageView

        DispatchQueue.main.async {
            self.scrollView.scroll(NSMakePoint(0, 0))
        }
    }

    func imageResize(srcImage: NSImage, newSize: (NSSize)) -> NSImage {
        let image = NSImage(size: newSize)

        image.lockFocus()
        srcImage.size = newSize
        NSGraphicsContext.current()!.imageInterpolation = .high
        srcImage.draw(at: NSZeroPoint, from: NSMakeRect(0, 0, newSize.width, newSize.height), operation: .copy, fraction: 1.0)
        image.unlockFocus()

        return image
    }

    func zoomImageSize() {

        let originalImage = ImageFileManager.shared.currentImage!

        let zoomFactor = CGFloat(1.2)

        if NSString(string: ImageFileManager.shared.currentImageFileName!).pathExtension.caseInsensitiveCompare("gif") == .orderedSame
                   && originalImage.isAnimationGif() == true {
            self.imageView!.frame.size = NSMakeSize(self.imageView!.frame.width * zoomFactor, self.imageView!.frame.height * zoomFactor)
        } else {
            let imageView = self.imageView as! NSImageView
            let factor = (imageView.image!.size.width / originalImage.size.width ) * zoomFactor

            let resizeImage = self.imageResize(srcImage: originalImage, newSize: NSMakeSize(originalImage.size.width * factor, originalImage.size.height * factor))
            self.imageView = NSImageView(image: resizeImage)
            self.imageView!.setFrameSize(NSMakeSize(resizeImage.size.width, resizeImage.size.height))
        }

        self.scrollView.documentView = self.imageView

    }

    func smallImageSize() {
        let originalImage = ImageFileManager.shared.currentImage!

        let zoomFactor = CGFloat(0.8)

        if NSString(string: ImageFileManager.shared.currentImageFileName!).pathExtension.caseInsensitiveCompare("gif") == .orderedSame
                   && originalImage.isAnimationGif() == true {
            self.imageView!.frame.size = NSMakeSize(self.imageView!.frame.width * zoomFactor, self.imageView!.frame.height * zoomFactor)
        } else {
            let imageView = self.imageView as! NSImageView
            let factor = (imageView.image!.size.width / originalImage.size.width ) * zoomFactor

            let resizeImage = self.imageResize(srcImage: originalImage, newSize: NSMakeSize(originalImage.size.width * factor, originalImage.size.height * factor))
            self.imageView = NSImageView(image: resizeImage)
            self.imageView!.setFrameSize(NSMakeSize(resizeImage.size.width, resizeImage.size.height))
        }

        self.scrollView.documentView = self.imageView
    }


}

