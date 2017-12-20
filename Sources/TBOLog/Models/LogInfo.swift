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
    let file: String
    let line: Int
    let function: String
    
    let tempInfoFlag: LogInfoFlag
    let tag: String?
    
    let dateString: String
    let tname: String

    var description: String {
        var desc = infoDesc()
        desc = desc.isEmpty ? "" : desc + ": "
        if let tag = tag {
            desc += tag + " "
        }
        desc += parseContent(content)
        desc += "\n"
        return desc
    }
    
    var contentDescription: String {
        return parseContent(content)
    }
    
    var dictionary: [String: Any] {
        var dict = [String: Any]()
        dict["level"] = level.description
        dict["content"] = content
        dict["file"] = file
        dict["line"] = line
        dict["function"] = function
        dict["tag"] = tag
        dict["date"] = dateString
        dict["tname"] = tname
        return dict
    }
    
    internal static let formatter = DateFormatter()

    init(level: Level,
         content: [Any],
         file: String,
         line: Int,
         function: String,
         tempInfoFlag: LogInfoFlag,
         tag: String?) {
        self.level = level
        self.content = content
        self.file = file
        self.line = line
        self.function = function
        self.tempInfoFlag = tempInfoFlag
        self.tag = tag
        self.dateString = type(of: self).formatter.string(from: Date())
        self.tname = type(of: self).threadName()
    }
}

extension LogInfo {
    static func prepareLogInfoDateFormat() {
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss.SSS"
    }
}

// MARK: - Private LogInfo Parse

private extension LogInfo {
    
    static func threadName() -> String {
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
    
    func infoDesc() -> String {
        func appended(desc: inout String,
                      additions: String,
                      front: String = " ",
                      handler: (() -> String)? = nil) {
            let front = desc.isEmpty ? "" : front
            desc += front + additions
            desc += handler?() ?? ""
        }
        
        var infoDesc = tempInfoFlag.check(.date) ? (dateString) : ""
        
        if tempInfoFlag.check(.file) {
            appended(desc: &infoDesc, additions: file) { self.tempInfoFlag.check(.lineNumber) ?  ":" + String(self.line) : "" }
        }
        
        if tempInfoFlag.check(.function) {
            appended(desc: &infoDesc, additions: function, front: "{") { return "}" }
        }
        
        if tempInfoFlag.check(.level) {
            appended(desc: &infoDesc, additions: level.description)
        }
        
        if tempInfoFlag.check(.threadName) {
            appended(desc: &infoDesc, additions: tname, front: "(") { return ")" }
        }
        return infoDesc
    }
    
    func parseContent(_ content: [Any]) -> String {
        let result = content.map { (item) -> String in
            let result: String
            if JSONSerialization.isValidJSONObject(item) {
                result = parseJsonContent(item)
            } else {
                result = parseNotJsonContent(item)
            }
            return result
        }
        return result.joined(separator: " ")
    }
    
    func parseJsonContent(_ content: Any) -> String {
        var result: Any = content
        do {
            let jsonData = try JSONSerialization.data(
                withJSONObject: content,
                options: .prettyPrinted)
            let json = String(
                data: jsonData,
                encoding: .utf8)
            if let jsonString = json {
                result = jsonString
            }
        } catch {
            print("TBOLog Error!", error.localizedDescription)
        }
        return String(describing: result)
    }
    
    func parseNotJsonContent(_ content: Any) -> String {
        let contentString = String(describing: content)
        return contentString
    }
} /** LogInfo */

// MARK: - LogInfoFlag

public struct LogInfoFlag: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let date          = LogInfoFlag(rawValue: 1 << 0)
    public static let time          = LogInfoFlag(rawValue: 1 << 1)
    public static let level         = LogInfoFlag(rawValue: 1 << 2)
    public static let threadName    = LogInfoFlag(rawValue: 1 << 3)
    public static let file          = LogInfoFlag(rawValue: 1 << 4)
    public static let lineNumber    = LogInfoFlag(rawValue: 1 << 5)
    public static let function      = LogInfoFlag(rawValue: 1 << 6)
    
    public static let full: LogInfoFlag  = [.date, .time, .level, .threadName, .file, .lineNumber, .function]
} /** LogInfoFlag */
