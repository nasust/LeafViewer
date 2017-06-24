//
// Created by hideki on 2017/06/20.
// Copyright (c) 2017 hideki. All rights reserved.
//

import Foundation
import Cocoa

protocol ImageFileManagerProto {
    var currentImage: NSImage? { get }
    var currentImageFileName: String? { get }
    var currentIndex: Int { get }
    var totalCount: Int { get }

    func doNext() -> Bool

    func doPrev() -> Bool

    func doFirst() -> Bool

    func doLast() -> Bool

    func hasNext() -> Bool

    func hasPrev() -> Bool

    func processFile(fileName: String) -> Bool

    static func isTargetFile(fileName: String) -> Bool
}
