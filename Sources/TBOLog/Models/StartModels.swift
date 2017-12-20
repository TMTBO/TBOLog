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
    
    init(level: Level = .verbose,
         loggers: [BaseLogger] = [ConsoleLogger.default],
         flag: LogInfoFlag = .full,
         path: String = "TBOLog",
         tag: String? = nil,
         isAsynchronously: Bool = true) {
        self.level = level
        self.loggers = loggers
        self.flag = flag
        self.path = path
        self.tag = tag
        self.isAsynchronously = isAsynchronously
    }
    
    public var defaultLogger = ConsoleLogger.default
}

extension StartConfiguration {
    mutating func append(logger: BaseLogger) {
        _ = loggers
            .filter { $0.identifier == logger.identifier }
            .map { remove(logger: $0) }
        loggers.append(logger)
    }

    mutating func remove(logger: BaseLogger) {
        guard loggers.contains(logger)else { return }
        guard let loggerIndex = loggers.index(of: logger) else { return }
        loggers.remove(at: loggerIndex)
    }

    func logger(identifier: String) -> BaseLogger? {
        return loggers.filter { $0.identifier.identifier == identifier }.first
    }
}
