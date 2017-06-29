//
// Created by hideki on 2017/06/19.
// Copyright (c) 2017 hideki. All rights reserved.
//

import Foundation
import Cocoa

class ImageFileManager: ImageFileManagerProto {

    static let shared: ImageFileManager = ImageFileManager()

    private var imageFileManagerImpl: ImageFileManagerProto?

    private init() {

    }

    var currentImage: NSImage? {
        get {
            return self.imageFileManagerImpl!.currentImage
        }
    }

    var currentImageFileName: String? {
        get {
            return self.imageFileManagerImpl!.currentImageFileName
        }
    }

    var currentIndex: Int {
        get {
            return self.imageFileManagerImpl!.currentIndex
        }
    }

    var totalCount: Int {
        get {
            return self.imageFileManagerImpl!.totalCount
        }
    }

    func doNext() -> Bool {
        return self.imageFileManagerImpl!.doNext()
    }

    func doPrev() -> Bool {
        return self.imageFileManagerImpl!.doPrev()
    }

    func doFirst() -> Bool {
        return self.imageFileManagerImpl!.doFirst()
    }

    func doLast() -> Bool {
        return self.imageFileManagerImpl!.doLast()
    }

    func hasNext() -> Bool {
        return self.imageFileManagerImpl!.hasNext()
    }

    func hasPrev() -> Bool {
        return self.imageFileManagerImpl!.hasPrev()
    }

    func imageData(fileName: String) -> Data?{
        return self.imageFileManagerImpl!.imageData(fileName: fileName)
    }

    static func isTargetFile(fileName: String) -> Bool {
        return false
    }

    func processFile(fileName: String) -> Bool {
        self.imageFileManagerImpl = nil
        if ImageFileSystemManager.isTargetFile(fileName: fileName) {
            self.imageFileManagerImpl = ImageFileSystemManager()
        } else if (ImageZipFileManager.isTargetFile(fileName: fileName)) {
            self.imageFileManagerImpl = ImageZipFileManager()
        }
        if self.imageFileManagerImpl != nil {
            return self.imageFileManagerImpl!.processFile(fileName: fileName)
        }
        return false
    }


}
