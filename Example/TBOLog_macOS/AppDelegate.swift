//
//  AppDelegate.swift
//  TBOLog_macOS
//
//  Created by TobyoTenma on 14/10/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import Cocoa
import TBOLog

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        TBOLog.start()
        TBOLog.d("Hello world")
        
        TBOLog.i("Log to ASL", destination: .appleSystemLog)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

