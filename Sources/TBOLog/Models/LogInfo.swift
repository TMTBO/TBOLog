//
//  LogInfo.swift
//  Pods
//
//  Created by TobyoTenma on 07/10/2017.
//

import Foundation

struct LogInfo {
    let level: Level
    let content: [Any]
    let fileName: String
    let line: Int
    let funcName: String
    let tempInfoTag: LogInfoTag
    
    let dateString = TBOLog.formatter.string(from: Date())
    var tname: String {
        let threadName: String
        if Thread.isMainThread {
            threadName = "main"
        } else {
            if let name = Thread.current.name,
                name.isEmpty == false {
                threadName = name
            } else {
                if let queueLabel = String(validatingUTF8: __dispatch_queue_get_label(nil)),
                    queueLabel.isEmpty == false {
                    threadName = queueLabel
                } else {
                    threadName = "\(Thread.current)"
                }
            }
        }
        return threadName
    }
    
    var description: String {
        func appended(desc: inout String,
                      additions: String,
                      handler: (() -> String)? = nil) {
            let front: String
            if desc.isEmpty {
                front = ""
            } else {
                front = "|"
            }
            desc += front + additions
            desc += handler?() ?? ""
        }
        
        var desc = tempInfoTag.check(.date) ? (dateString) : ""
        if tempInfoTag.check(.level) {
            appended(desc: &desc, additions: level.description)
        }
        
        if tempInfoTag.check(.threadName) {
            appended(desc: &desc, additions: tname)
        }
        
        if tempInfoTag.check(.fileName) {
            appended(desc: &desc, additions: fileName) { () -> String in
                if self.tempInfoTag.check(.lineNumber) {
                    return ":" + String(self.line)
                } else {
                    return ""
                }
            }
        }
        
        if tempInfoTag.check(.funcName) {
            appended(desc: &desc, additions: "{\(funcName)}")
        }
        return desc.isEmpty ? "" : desc + ":"
    }
}

public struct LogInfoTag: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let date          = LogInfoTag(rawValue: 1 << 0)
    public static let level         = LogInfoTag(rawValue: 1 << 1)
    public static let threadName         = LogInfoTag(rawValue: 1 << 2)
    public static let fileName      = LogInfoTag(rawValue: 1 << 3)
    public static let lineNumber    = LogInfoTag(rawValue: 1 << 4)
    public static let funcName      = LogInfoTag(rawValue: 1 << 5)
    
    public static let full: LogInfoTag  = [.date, .level, .threadName, .fileName, .lineNumber, .funcName]
    
    func check(_ infoTag: LogInfoTag) -> Bool {
        return contains(infoTag)
    }
}
