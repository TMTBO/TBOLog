//
//  ConsoleLogger.swift
//  Nimble-iOS
//
//  Created by TobyoTenma on 04/10/2017.
//

import Foundation

enum ConsoleLogger {
//    case all
//    case debug
//    case info
//    case warn
//    case error
//    case none
    
    case msg(_: String?)
    case url(_: URL?)
    case error(_: NSError?)
    case date(_: NSDate?)
    case obj(_: AnyObject?)
    case any(_: Any?)
    
    case comeHere()
}

postfix operator /

postfix func / (target: ConsoleLogger?) {
    guard let target = target else { return }
    
    func log<T>(emoji: String, _ object: T?) {
        //        #if DEBUG
        guard object != nil, let object = object else {
            print("😒 " + "You got a nil")
            return
        }
        print(emoji + " " + String(describing: object))
        //        #endif
    }
    
    switch target {
    case .msg(let msg):
        log(emoji: "✏️", msg)
    case .url(let url):
        log(emoji: "🌏", url)
        
    case .error(let error):
        log(emoji: "❗️", error)
        
    case .any(let any):
        log(emoji: "⚪️", any)
        
    case .obj(let obj):
        log(emoji: "💼", obj)
        
    case .date(let date):
        log(emoji: "🕒", date)
        
    case .comeHere():
        log(emoji: "🤓", "Come Here")
    }
    
}
