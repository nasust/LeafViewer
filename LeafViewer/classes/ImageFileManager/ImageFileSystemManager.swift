//
// Created by hideki on 2017/06/20.
// Copyright (c) 2017 hideki. All rights reserved.
//

import Foundation
import Cocoa

class ImageFileSystemManager: ImageFileManagerProto {
    static let typeExtensions: [String] = ["jpg", "jpeg", "png", "gif", "bmp"]

    static func isTargetFile(fileName: String) -> Bool {

        let fileManager = FileManager.default
        var isDir: ObjCBool = false

        if fileManager.fileExists(atPath: fileName, isDirectory: &isDir) {
            if isDir.boolValue {

                do {
                    let files = try fileManager.contentsOfDirectory(atPath: fileName)
                    for file in files {
                        for fileType in ImageFileSystemManager.typeExtensions {
                            if NSString(string: file).pathExtension.caseInsensitiveCompare(fileType) == .orderedSame {
                                return true
                            }
                        }
                    }
                } catch {
                    return false
                }

            } else {
                for fileType in typeExtensions {
                    if NSString(string: fileName).pathExtension.caseInsensitiveCompare(fileType) == .orderedSame {
                        return true
                    }
                }
            }
        }

        return false
    }

    private var directoryImageFiles = [String]()
    private var currentImageIndex = 0

    var currentImage: NSImage? {
        get {
            if self.directoryImageFiles.count > 0 {
                let image = NSImage(contentsOfFile: directoryImageFiles[currentImageIndex])

                var width = 0
                var height = 0

                for imageRep in image!.representations {
                    if imageRep.pixelsWide > width {
                        width = imageRep.pixelsWide
                    }
                    if imageRep.pixelsHigh > height {
                        height = imageRep.pixelsHigh
                    }
                }

                let viewImage = NSImage(size: NSMakeSize(CGFloat(width), CGFloat(height)))
                viewImage.addRepresentations(image!.representations)

                return viewImage

            } else {
                return nil
            }
        }
    }

    var currentImageFileName: String? {
        get {
            if self.directoryImageFiles.count > 0 {
                return directoryImageFiles[currentImageIndex]
            } else {
                return nil
            }
        }
    }

    var currentIndex: Int {
        get {
            return self.currentImageIndex
        }
    }

    var totalCount: Int {
        get {
            return self.directoryImageFiles.count
        }
    }

    func doNext() -> Bool {
        if (self.currentImageIndex + 1 < directoryImageFiles.count) {
            self.currentImageIndex += 1
            return true
        }
        return false
    }

    func doPrev() -> Bool {
        if (self.currentImageIndex - 1 >= 0) {
            self.currentImageIndex -= 1
            return true
        }
        return false
    }

    func doFirst() -> Bool {
        if self.directoryImageFiles.count > 0 {
            self.currentImageIndex = 0
            return true
        }
        return true
    }

    func doLast() -> Bool {
        if self.directoryImageFiles.count > 0 {
            self.currentImageIndex = self.directoryImageFiles.count - 1
            return true
        }
        return true
    }

    func hasNext() -> Bool {
        return self.currentImageIndex + 1 < directoryImageFiles.count
    }

    func hasPrev() -> Bool {
        return self.currentImageIndex - 1 >= 0
    }

    init() {
    }

    func processFile(fileName: String) -> Bool {
        let fileManager = FileManager.default
        var isDir: ObjCBool = false

        if fileManager.fileExists(atPath: fileName, isDirectory: &isDir) {
            if isDir.boolValue {
                return self.processImageDirectory(directory: fileName)
            } else {
                return self.processImageFile(fileName: fileName)
            }
        }
        return false
    }

    private func processImageFile(fileName: String) -> Bool {
        let directoryPath = NSString(string: fileName).deletingLastPathComponent

        if self.processImageDirectory(directory: directoryPath) {
            self.currentImageIndex = self.directoryImageFiles.index(of: fileName)!
            return true
        }

        return false
    }

    private func processImageDirectory(directory: String) -> Bool {
        let fileManager = FileManager.default
        var currentDirectoryImageFiles = [String]()

        do {
            let files = try fileManager.contentsOfDirectory(atPath: directory)
            for file in files {

                var hit = false;
                for fileType in ImageFileSystemManager.typeExtensions {
                    if NSString(string: file).pathExtension.caseInsensitiveCompare(fileType) == .orderedSame {
                        hit = true
                        break
                    }
                }

                if hit {
                    currentDirectoryImageFiles.append(directory + "/" + file)
                }

            }

        } catch {
            return false
        }

        self.directoryImageFiles = currentDirectoryImageFiles.sorted()
        self.currentImageIndex = 0

        return true
    }

    func imageData(fileName: String) -> Data?{
        return NSData(contentsOfFile: fileName) as Data!
    }

}
