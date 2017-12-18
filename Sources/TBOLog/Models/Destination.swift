//
//  Destination.swift
//  Pods
//
//  Created by TobyoTenma on 07/10/2017.
//

import Foundation

public struct Destination: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let console           = Destination(rawValue: 1 << 0)
    public static let appleSystemLog    = Destination(rawValue: 1 << 1)
    public static let file              = Destination(rawValue: 1 << 2)
    
    public static let all: Destination  = [.console, .file]
    
    var description: String {
        switch self {
        case .console:
            return "Console"
        case .appleSystemLog:
            return "AppleSystemLog"
        case .file:
            return "File(Documents\\\(TBOLog.config.path)"
        case .all:
            return "[Console, AppleSystemLog, File(\\\(TBOLog.config.path)]"
        default:
            return "Undefined Destination"
        }
    }
    
    func getLoggers() -> [QueueLogger] {
        var loggers = [QueueLogger]()
        if contains(.console) {
//            loggers.append(ConsoleLogger.shared)
        }
        if contains(.appleSystemLog) {
//            loggers.append(ASLLogger.shared)
        }
        if contains(.file) {
            
        }
        return loggers
    }
}
