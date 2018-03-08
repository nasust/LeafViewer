//
// Created by hideki on 2017/06/22.
// Copyright (c) 2017 hideki. All rights reserved.
//

import Foundation

class App {
    static let keyViewMode = "viewMode"
    static let keyCenterWindow = "centerWindow"
    static let keyRecentFile = "recentFile"
    static let keyToolBarHide = "toolBarHide"

    static var configIsCenterWindow: Bool {
        get {
            if UserDefaults.standard.object(forKey: App.keyCenterWindow) != nil {
                return UserDefaults.standard.bool(forKey: App.keyCenterWindow)
            } else {
                return true
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: App.keyCenterWindow)
        }
    }

    static var configViewMode: ViewMode {
        get {
            if UserDefaults.standard.object(forKey: App.keyViewMode) != nil {
                return ViewMode(rawValue: UserDefaults.standard.integer(forKey: App.keyViewMode))!
            } else {
                return ViewMode.automaticZoom
            }
        }

        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: App.keyViewMode)
        }
    }

    static func addRecentOpenFile(fileName: String) {

        var recentFiles = Array<String>()

        if UserDefaults.standard.object(forKey: App.keyRecentFile) != nil {
            recentFiles = UserDefaults.standard.stringArray(forKey: App.keyRecentFile)!
        }

        recentFiles.insert(fileName, at: 0)

        if recentFiles.count > 10 {
            recentFiles.removeLast()
        }

        UserDefaults.standard.set(recentFiles, forKey: App.keyRecentFile)
    }

    static var recentOpenFile: Array<String> {
        get {
            var recentFiles = Array<String>()

            if UserDefaults.standard.object(forKey: App.keyRecentFile) != nil {
                recentFiles = UserDefaults.standard.stringArray(forKey: App.keyRecentFile)!
            }

            return recentFiles
        }
    }

    static var hideToolBar: Bool {
        get {
            if UserDefaults.standard.object(forKey: App.keyToolBarHide) != nil {
                return UserDefaults.standard.bool(forKey: App.keyToolBarHide)
            } else {
                return false
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: App.keyToolBarHide)
        }
    }


}
