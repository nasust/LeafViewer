//
// Created by hideki on 2017/06/26.
// Copyright (c) 2017 hideki. All rights reserved.
//

import Foundation
import ZipUtilities

class ImageZipFileManager: ImageFileManagerProto {

    static func isTargetFile(fileName: String) -> Bool {
        if NSString(string: fileName).pathExtension.caseInsensitiveCompare("zip") != .orderedSame {
            return false
        }

        let unZipper = NOZUnzipper.init(zipFile: fileName)

        do {
            try unZipper.open()
            _ = try unZipper.readCentralDirectory()
        } catch {
            return false
        }

        defer{
            do {
                try unZipper.close()
            } catch {
                abort()
            }
        }

        var result = false

        unZipper.enumerateManifestEntries({ record, index, stop -> Void in
            let pathExtension = NSString(string: record.name).pathExtension

            for fileType in ImageFileSystemManager.typeExtensions {
                if pathExtension.caseInsensitiveCompare(fileType) == .orderedSame {
                    stop.pointee = ObjCBool.init(true)
                    result = true
                    break
                }
            }
        })

        return result
    }

    private var directoryImageFiles = [String]()
    private var currentImageIndex = 0
    private var zipFile: String?

    func processFile(fileName: String) -> Bool {
        self.directoryImageFiles.removeAll()

        let unZipper = NOZUnzipper.init(zipFile: fileName)

        do {
            try unZipper.open()
            _ = try unZipper.readCentralDirectory()
        } catch {
            return false
        }

        defer{
            do {
                try unZipper.close()
            } catch {
                abort()
            }
        }

        unZipper.enumerateManifestEntries({ [weak self] record, index, stop -> Void in
            let pathExtension = NSString(string: record.name).pathExtension

            for fileType in ImageFileSystemManager.typeExtensions {
                if pathExtension.caseInsensitiveCompare(fileType) == .orderedSame {
                    if record.isMacOSXAttribute() == false && record.isMacOSXDSStore() == false && record.isZeroLength() == false {
                        self!.directoryImageFiles.append(record.name)
                    }
                    break
                }
            }
        })

        self.currentImageIndex = 0
        self.zipFile = fileName

        return directoryImageFiles.count > 0
    }

    var currentImage: NSImage? {
        get {
            if self.directoryImageFiles.count > 0 {

                if let data = self.findRecordData(fileName: self.currentImageFileName!) {
                    return NSImage(data: data)
                } else {
                    return nil
                }

            } else {
                return nil
            }
        }
    }

    private func findRecordData(fileName: String) -> Data? {
        if self.directoryImageFiles.count > 0 {

            let unZipper = NOZUnzipper.init(zipFile: self.zipFile!)

            do {
                try unZipper.open()
                _ = try unZipper.readCentralDirectory()
            } catch {
                return nil
            }

            defer{
                do {
                    try unZipper.close()
                } catch {
                    abort()
                }
            }

            var resultData: Data?

            unZipper.enumerateManifestEntries({ [weak self] record, index, stop -> Void in
                if record.name == self!.currentImageFileName! {
                    stop.pointee = ObjCBool.init(true)
                    if let data = self!.readRecord(unZipper: unZipper, record: record) {
                        resultData = data
                    }
                }

            })

            return resultData

        } else {
            return nil
        }
    }

    private func readRecord(unZipper: NOZUnzipper, record: NOZCentralDirectoryRecord) -> Data? {
        let data = NSMutableData(capacity: Int(record.uncompressedSize))

        do {
            try unZipper.enumerateByteRanges(of: record, progressBlock: nil, using: { bytes, byteRange, stop -> Void in
                data?.append(bytes, length: byteRange.length)
            })
        } catch {
            return nil
        }

        return data as Data?
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

    func imageData(fileName: String) -> Data? {
        return self.findRecordData(fileName: fileName)
    }


}
