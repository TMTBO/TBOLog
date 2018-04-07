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
        TBOLog.i("Log to ASL")
        
        let queue = OperationQueue()
        let op = BlockOperation {
            print("ready to sleep")
            sleep(2)
            print("sleeped")
        }
        let op1 = BlockOperation {
            print("------hello")
        }
        queue.addOperation(op)
        queue.addOperation(op1)
        queue.isSuspended = true
        print("ops count: \(queue.operationCount)")
        _ = queue.operations.map { (op) in
            print("ops: ", op)
            (op as? BlockOperation)?.start()
        }
        
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

