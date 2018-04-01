//
// Created by hideki on 2017/06/23.
// Copyright (c) 2017 hideki. All rights reserved.
//

import Foundation
import Cocoa

extension AppDelegate {

    func setupToolBar() {
        let mainMenu = NSApplication.shared.mainMenu
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
                                        viewOptionMenuItem.state = App.configIsCenterWindow ? NSControl.StateValue.on : NSControl.StateValue.off                                    case 2: //実際のサイズ
                                        viewOptionMenuItem.action = #selector(AppDelegate.menuItemActionOriginalSize(sender:))
                                        viewOptionMenuItem.state = App.configViewMode == ViewMode.original ? NSControl.StateValue.on : NSControl.StateValue.off

                                    case 3: //ウィンドウに合わせる
                                        viewOptionMenuItem.action = #selector(AppDelegate.menuItemActionJustWindow(sender:))
                                        viewOptionMenuItem.state = App.configViewMode == ViewMode.justWindow ? NSControl.StateValue.on : NSControl.StateValue.off

                                    case 4: //画面に合わせる
                                        viewOptionMenuItem.action = #selector(AppDelegate.menuItemActionAutomaticZoom(sender:))
                                        viewOptionMenuItem.state = App.configViewMode == ViewMode.automaticZoom ? NSControl.StateValue.on : NSControl.StateValue.off

                                    case 5: //画面より大きい場合縮小する
                                        viewOptionMenuItem.action = #selector(AppDelegate.menuItemActionReduceDisplayLargerScreen(sender:))
                                        viewOptionMenuItem.state = App.configViewMode == ViewMode.reduceDisplayLargerScreen ? NSControl.StateValue.on : NSControl.StateValue.off

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

    @objc func menuItemActionOpenFile(sender: NSMenuItem) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.allowedFileTypes = ["jpg", "jpeg", "gif", "png", "bmp"]
        openPanel.begin(completionHandler: { (result) -> Void in
            if result.rawValue == NSFileHandlingPanelOKButton {
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

    @objc func menuItemActionRecentOpenFile(sender: NSMenuItem) {
        self.processImageFile(sender.title)
    }

    @objc func menuItemActionCenterWindow(sender: NSMenuItem) {
        if (sender.state == NSControl.StateValue.on) {
            sender.state = NSControl.StateValue.off
            App.configIsCenterWindow = false
        } else {
            sender.state = NSControl.StateValue.on
            App.configIsCenterWindow = true
        }
    }

    @objc func menuItemActionOriginalSize(sender: NSMenuItem) {
        self.menuItemOriginalSize.state = NSControl.StateValue.on
        self.menuItemJustWindow.state = NSControl.StateValue.off
        self.menuItemAutomaticZoom.state = NSControl.StateValue.off
        self.menuItemReduceDisplayLargerScreen.state = NSControl.StateValue.off

        App.configViewMode = ViewMode.original

        if self.imageWindowController != nil {
            self.imageWindowController!.refreshImage()
        }
    }

    @objc func menuItemActionJustWindow(sender: NSMenuItem) {
        self.menuItemOriginalSize.state = NSControl.StateValue.off
        self.menuItemJustWindow.state = NSControl.StateValue.on
        self.menuItemAutomaticZoom.state = NSControl.StateValue.off
        self.menuItemReduceDisplayLargerScreen.state = NSControl.StateValue.off

        App.configViewMode = ViewMode.justWindow
        if self.imageWindowController != nil {
            self.imageWindowController!.refreshImage()
        }
    }

    @objc func menuItemActionAutomaticZoom(sender: NSMenuItem) {
        self.menuItemOriginalSize.state = NSControl.StateValue.off
        self.menuItemJustWindow.state = NSControl.StateValue.off
        self.menuItemAutomaticZoom.state = NSControl.StateValue.on
        self.menuItemReduceDisplayLargerScreen.state = NSControl.StateValue.off

        App.configViewMode = ViewMode.automaticZoom
        if self.imageWindowController != nil {
            self.imageWindowController!.refreshImage()
        }
    }

    @objc func menuItemActionReduceDisplayLargerScreen(sender: NSMenuItem) {
        self.menuItemOriginalSize.state = NSControl.StateValue.off
        self.menuItemJustWindow.state = NSControl.StateValue.off
        self.menuItemAutomaticZoom.state = NSControl.StateValue.off
        self.menuItemReduceDisplayLargerScreen.state = NSControl.StateValue.on

        App.configViewMode = ViewMode.reduceDisplayLargerScreen
        if self.imageWindowController != nil {
            self.imageWindowController!.refreshImage()
        }
    }

    @objc func menuItemActionNext(sender: NSMenuItem) {
        if self.imageWindowController != nil {
            _ = self.imageWindowController!.nextImage()
        }
    }

    @objc func menuItemActionPrev(sender: NSMenuItem) {
        if self.imageWindowController != nil {
            _ = self.imageWindowController!.prevImage()
        }
    }

    @objc func menuItemActionFirst(sender: NSMenuItem) {
        if self.imageWindowController != nil {
            _ = self.imageWindowController!.firstImage()
        }
    }

    @objc func menuItemActionLast(sender: NSMenuItem) {
        if self.imageWindowController != nil {
            _ = self.imageWindowController!.lastImage()
        }
    }

    @objc func menuItemActionDoOriginalSize(sender: NSMenuItem) {
        if self.imageWindowController != nil {
            _ = self.imageWindowController!.originalImageSize()
        }
    }

    @objc func menuItemActionZoom(sender: NSMenuItem) {
        if self.imageWindowController != nil {
            _ = self.imageWindowController!.zoomImageSize()
        }
    }

    @objc func menuItemActionReduction(sender: NSMenuItem) {
        if self.imageWindowController != nil {
            _ = self.imageWindowController!.smallImageSize()
        }
    }

    @objc func menuItemActionShowToolBar(sender: NSMenuItem) {
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

    @objc func menuItemActionHelp(sender: NSMenuItem) {
        let url = URL(string: "http://nasust.hatenablog.com/entry/leafviewer")!
        NSWorkspace.shared.open(url)
    }


}
