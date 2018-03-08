//
// Created by hideki on 2017/06/23.
// Copyright (c) 2017 hideki. All rights reserved.
//

import Foundation
import Cocoa

extension AppDelegate {

    func setupToolBar() {
        let mainMenu = NSApplication.shared().mainMenu
        for menuItem in mainMenu!.items {
            //menuItem.target = self

            switch menuItem.tag {
            case 1: break
            case 2: //file
                if let fileMenu = menuItem.submenu {
                    for fileMenuItem in fileMenu.items {
                        switch fileMenuItem.tag {
                        case 1: //ファイルを開く
                            fileMenuItem.action = #selector(AppDelegate.menuItemActionOpenFile(sender:))
                        case 2: //最近のファイルを開く
                            self.setupMenuItemRecentOpenFile()
                        default: break;
                        }
                    }
                }
            case 3: //View
                if let viewMenu = menuItem.submenu {
                    for viewMenuItem in viewMenu.items {

                        switch viewMenuItem.tag {
                        case 1: //表示オプション
                            if let viewOptionMenu = viewMenuItem.submenu {
                                for viewOptionMenuItem in viewOptionMenu.items {


                                    switch viewOptionMenuItem.tag {
                                    case 1: //ウィンドウを画面の中央に表示する
                                        viewOptionMenuItem.action = #selector(AppDelegate.menuItemActionCenterWindow(sender:))
                                        viewOptionMenuItem.state = App.configIsCenterWindow ? NSOnState : NSOffState
                                    case 2: //実際のサイズ
                                        viewOptionMenuItem.action = #selector(AppDelegate.menuItemActionOriginalSize(sender:))
                                        viewOptionMenuItem.state = App.configViewMode == ViewMode.original ? NSOnState : NSOffState

                                    case 3: //ウィンドウに合わせる
                                        viewOptionMenuItem.action = #selector(AppDelegate.menuItemActionJustWindow(sender:))
                                        viewOptionMenuItem.state = App.configViewMode == ViewMode.justWindow ? NSOnState : NSOffState

                                    case 4: //画面に合わせる
                                        viewOptionMenuItem.action = #selector(AppDelegate.menuItemActionAutomaticZoom(sender:))
                                        viewOptionMenuItem.state = App.configViewMode == ViewMode.automaticZoom ? NSOnState : NSOffState

                                    case 5: //画面より大きい場合縮小する
                                        viewOptionMenuItem.action = #selector(AppDelegate.menuItemActionReduceDisplayLargerScreen(sender:))
                                        viewOptionMenuItem.state = App.configViewMode == ViewMode.reduceDisplayLargerScreen ? NSOnState : NSOffState

                                    default: break;
                                    }

                                }
                            }

                        case 2: //次へ
                            viewMenuItem.action = #selector(AppDelegate.menuItemActionNext(sender:))
                        case 3: //前へ
                            viewMenuItem.action = #selector(AppDelegate.menuItemActionPrev(sender:))
                        case 4: //先頭へ
                            viewMenuItem.action = #selector(AppDelegate.menuItemActionFirst(sender:))
                        case 5: //最後へ
                            viewMenuItem.action = #selector(AppDelegate.menuItemActionLast(sender:))
                        case 6: //実際のサイズ
                            viewMenuItem.action = #selector(AppDelegate.menuItemActionDoOriginalSize(sender:))
                        case 7: //拡大
                            viewMenuItem.action = #selector(AppDelegate.menuItemActionZoom(sender:))
                        case 8: //縮小
                            viewMenuItem.action = #selector(AppDelegate.menuItemActionReduction(sender:))
                        case 9: //ツールバーを表示する
                            viewMenuItem.action = #selector(AppDelegate.menuItemActionShowToolBar(sender:))
                            viewMenuItem.title = App.hideToolBar ? "ツールバーを表示する" : "ツールバーを隠す"
                        case 10: break//フルスクリーン
                        default: break
                        }

                    }
                }
            case 4: //help
                if let helpMenu = menuItem.submenu {
                    for helpMenuItem in helpMenu.items {
                        switch helpMenuItem.tag {
                        case 1:
                            helpMenuItem.action = #selector(AppDelegate.menuItemActionHelp(sender:))
                        default: break
                        }

                    }
                }
            default: break
            }


        }
    }

    func menuItemActionOpenFile(sender: NSMenuItem) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.allowedFileTypes = ["jpg", "jpeg", "gif", "png", "bmp"]
        openPanel.begin(completionHandler: { (result) -> Void in
            if result == NSFileHandlingPanelOKButton {
                if let url = openPanel.url {
                    self.processImageFile(url.path)
                }
            }
        })

    }

    func setupMenuItemRecentOpenFile() {
        let recentOpenFileMenu = NSMenu(title: "")
        for recentOpenFilePath in App.recentOpenFile {
            NSLog("recentOpenFilePath: %@", recentOpenFilePath)
            let recentOpenFileMenuItem = NSMenuItem(title: recentOpenFilePath, action: #selector(AppDelegate.menuItemActionRecentOpenFile(sender:)), keyEquivalent: "")
            recentOpenFileMenu.addItem(recentOpenFileMenuItem)
        }
        recentOpenFileMenu.update()
        self.menuItemRecentOpenFile.submenu = recentOpenFileMenu
    }

    func menuItemActionRecentOpenFile(sender: NSMenuItem) {
        self.processImageFile(sender.title)
    }

    func menuItemActionCenterWindow(sender: NSMenuItem) {
        if (sender.state == NSOnState) {
            sender.state = NSOffState
            App.configIsCenterWindow = false
        } else {
            sender.state = NSOnState
            App.configIsCenterWindow = true
        }
    }

    func menuItemActionOriginalSize(sender: NSMenuItem) {
        self.menuItemOriginalSize.state = NSOnState
        self.menuItemJustWindow.state = NSOffState
        self.menuItemAutomaticZoom.state = NSOffState
        self.menuItemReduceDisplayLargerScreen.state = NSOffState

        App.configViewMode = ViewMode.original

        if self.imageWindowController != nil {
            self.imageWindowController!.refreshImage()
        }
    }

    func menuItemActionJustWindow(sender: NSMenuItem) {
        self.menuItemOriginalSize.state = NSOffState
        self.menuItemJustWindow.state = NSOnState
        self.menuItemAutomaticZoom.state = NSOffState
        self.menuItemReduceDisplayLargerScreen.state = NSOffState

        App.configViewMode = ViewMode.justWindow
        if self.imageWindowController != nil {
            self.imageWindowController!.refreshImage()
        }
    }

    func menuItemActionAutomaticZoom(sender: NSMenuItem) {
        self.menuItemOriginalSize.state = NSOffState
        self.menuItemJustWindow.state = NSOffState
        self.menuItemAutomaticZoom.state = NSOnState
        self.menuItemReduceDisplayLargerScreen.state = NSOffState

        App.configViewMode = ViewMode.automaticZoom
        if self.imageWindowController != nil {
            self.imageWindowController!.refreshImage()
        }
    }

    func menuItemActionReduceDisplayLargerScreen(sender: NSMenuItem) {
        self.menuItemOriginalSize.state = NSOffState
        self.menuItemJustWindow.state = NSOffState
        self.menuItemAutomaticZoom.state = NSOffState
        self.menuItemReduceDisplayLargerScreen.state = NSOnState

        App.configViewMode = ViewMode.reduceDisplayLargerScreen
        if self.imageWindowController != nil {
            self.imageWindowController!.refreshImage()
        }
    }

    func menuItemActionNext(sender: NSMenuItem) {
        if self.imageWindowController != nil {
            _ = self.imageWindowController!.nextImage()
        }
    }

    func menuItemActionPrev(sender: NSMenuItem) {
        if self.imageWindowController != nil {
            _ = self.imageWindowController!.prevImage()
        }
    }

    func menuItemActionFirst(sender: NSMenuItem) {
        if self.imageWindowController != nil {
            _ = self.imageWindowController!.firstImage()
        }
    }

    func menuItemActionLast(sender: NSMenuItem) {
        if self.imageWindowController != nil {
            _ = self.imageWindowController!.lastImage()
        }
    }

    func menuItemActionDoOriginalSize(sender: NSMenuItem) {
        if self.imageWindowController != nil {
            _ = self.imageWindowController!.originalImageSize()
        }
    }

    func menuItemActionZoom(sender: NSMenuItem) {
        if self.imageWindowController != nil {
            _ = self.imageWindowController!.zoomImageSize()
        }
    }

    func menuItemActionReduction(sender: NSMenuItem) {
        if self.imageWindowController != nil {
            _ = self.imageWindowController!.smallImageSize()
        }
    }

    func menuItemActionShowToolBar(sender: NSMenuItem) {
        if self.imageWindowController != nil {
            if self.imageWindowController!.window!.toolbar!.isVisible {
                self.imageWindowController!.window!.toolbar!.isVisible = false
                App.hideToolBar = true
                sender.title = "ツールバーを表示する"
            } else {
                self.imageWindowController!.window!.toolbar!.isVisible = true
                App.hideToolBar = false
                sender.title = "ツールバーを隠す"
            }
        }
    }

    func menuItemActionHelp(sender: NSMenuItem) {
        let url = URL(string: "http://nasust.hatenablog.com/entry/leafviewer")!
        NSWorkspace.shared().open(url)
    }


}
