//
//  BaseLogger.swift
//  Pods
//
//  Created by TobyoTenma on 14/10/2017.
//

import Foundation

open class BaseLogger {

    public let identifier: LoggerIdentifier

    init(identifier: String = "") {
        self.identifier = LoggerIdentifier(identifier: identifier)
    }

    func flush(_ info: LogInfo, isAsynchronously: Bool) {
        precondition(false, "This Method Must Be Override!")
    }

    func write(_ info: LogInfo) {
        precondition(false, "This Method Must Be Override!")
    }
}

extension BaseLogger: Equatable {
    public static func ==(lhs: BaseLogger, rhs: BaseLogger) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

public struct LoggerIdentifier: Equatable {
    var identifier: String
    
    public static func ==(lhs: LoggerIdentifier, rhs: LoggerIdentifier) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
