//
//  BaseLogger.swift
//  Pods
//
//  Created by TobyoTenma on 14/10/2017.
//

import Foundation

open class BaseLogger {

    let identifier: String

    init(identifier: String = "") {
        self.identifier = identifier
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
