//
//  StartModels.swift
//  Pods
//
//  Created by TobyoTenma on 07/10/2017.
//

import Foundation

public struct StartResult {
    public var isSuccess: Bool
    public var reason: String? = nil
}

public struct StartConfiguration {
    public var level: Level = .verbose
    public var loggers: [BaseLogger] = [ConsoleLogger.default]
    public var flag: LogInfoFlag = .full
    public var path: String = "TBOLog"
    public var tag: String? = nil
    public var isAsynchronously = true
}

extension StartConfiguration {
    mutating func append(logger: BaseLogger) {
        loggers.append(logger)
    }

    mutating func remove(logger: BaseLogger) {
        guard loggers.contains(logger)else { return }
        guard let loggerIndex = loggers.index(of: logger) else { return }
        loggers.remove(at: loggerIndex)
    }

    mutating func replace(identifier: String, with logger: BaseLogger) {
        guard let oldLogger = self.logger(identifier: identifier),
              let loggerIndex = loggers.index(of: oldLogger) else {
            append(logger: logger)
            return
        }
        loggers[loggerIndex] = logger
    }

    func logger(identifier: String) -> BaseLogger? {
        return loggers.filter { $0.identifier == identifier }.first
    }
}
