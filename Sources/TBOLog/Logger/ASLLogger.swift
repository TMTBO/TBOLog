//
//  ASLLogger.swift
//  Pods
//
//  Created by TobyoTenma on 14/10/2017.
//

import Foundation
import asl
import os.log

class ASLLogger: QueueLogger {
    
    static let shared = ASLLogger()
    
    private var log: OSLog! = nil
    private var client: aslclient! = nil
    
    private let subsystem = "com.apple.console"
    private let category = "TBOLog"
    
    override private init() {
        if #available(OSX 10.12, iOS 10.0, *) {
            log = OSLog(subsystem: subsystem, category: category)
        } else {
            client = asl_open(nil, subsystem, UInt32(ASL_OPT_STDERR))
        }
        super.init()
    }
    
    override func write(_ info: LogInfo) {
        if #available(OSX 10.12, iOS 10.0, *) {
            osLogWrite(info)
        } else {
            aslWrite(info)
        }
    }
}

private extension ASLLogger {
    @available(OSX 10.12, iOS 10.0, *)
    func osLogWrite(_ info: LogInfo) {
        os_log("%@", log: log, type: oslogType(info.level), info.contentDescription)
    }

    func aslWrite(_ info: LogInfo) {
        let msg = asl_new(UInt32(ASL_TYPE_MSG))
        asl_set(msg, ASL_KEY_FACILITY, subsystem)
        asl_set(msg, ASL_KEY_LEVEL, aslLevel(info.level))
        asl_set(msg, ASL_KEY_MSG, info.contentDescription)
        asl_set(msg, "TBOLOG_KEY", "10000")
        asl_send(client, msg)
        asl_free(msg)
    }
    
    @available(OSX 10.12, iOS 10.0, *)
    func oslogType(_ level: Level) -> OSLogType {
        switch level {
        case .error:
            return OSLogType.error
        case .warning:
            return OSLogType.fault
        case .info:
            return OSLogType.default
        case .debug, .verbose: // Do not out put in Console.app
            return OSLogType.debug
        default: // Do not out put in Console.app
            return OSLogType.info
        }
    }
    
    func aslLevel(_ level: Level) -> String {
        switch level {
        case .error:
            return "\(ASL_LEVEL_CRIT)"
        case .warning:
            return "\(ASL_LEVEL_ERR)"
        case .info:
            return "\(ASL_LEVEL_WARNING)"
        case .debug, .verbose: // Do not out put in Console.app
            return "\(ASL_LEVEL_DEBUG)"
        default: // Do not out put in Console.app
            return "\(ASL_LEVEL_INFO)"
        }
    }
}

// MARK: - Test Method

extension ASLLogger {
    @available(OSX 10.12, iOS 10.0, *)
    func testOSLogWrite(_ info: LogInfo) {
        osLogWrite(info)
    }
    
    func testASLWrite(_ info: LogInfo) {
        aslWrite(info)
    }
    
    @available(OSX 10.12, iOS 10.0, *)
    func testOSLogType(_ level: Level) -> OSLogType {
        return oslogType(level)
    }
    
    func testASLLevel(_ level: Level) -> String {
        return aslLevel(level)
    }
}
