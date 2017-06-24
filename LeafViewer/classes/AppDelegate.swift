//
//  AppDelegate.swift
//  LeafViewer
//
//  Created by hideki on 2017/06/19.
//  Copyright © 2017年 hideki. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var imageWindowController: ImageWindowController?
    
    @IBOutlet weak var menuItemRecentOpenFile: NSMenuItem!
    
    @IBOutlet weak var menuItemOriginalSize: NSMenuItem!
    @IBOutlet weak var menuItemJustWindow: NSMenuItem!
    @IBOutlet weak var menuItemAutomaticZoom : NSMenuItem!
    @IBOutlet weak var menuItemReduceDisplayLargerScreen : NSMenuItem!


    

    public func applicationWillFinishLaunching(_ notification: Notification) {
        self.setupToolBar()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        NSLog("fileName %@", filename)
        self.processImageFile(filename)
        return true
    }

    func processImageFile(_ fileName: String) {
        if ImageFileManager.shared.processFile(fileName: fileName) {
            App.addRecentOpenFile(fileName: fileName)
            self.setupMenuItemRecentOpenFile()
            self.showImageViewer()
        } else {
            //todo alert
        }
    }

    func showImageViewer() {
        if self.imageWindowController == nil {
            let storyBord = NSStoryboard(name: "Image", bundle: nil)
            self.imageWindowController = storyBord.instantiateInitialController() as! ImageWindowController?
            self.imageWindowController!.window!.makeKeyAndOrderFront(nil)
        } else {
            self.imageWindowController!.window!.makeKeyAndOrderFront(nil)
            self.imageWindowController!.refreshImage()
        }
    }
    



}

