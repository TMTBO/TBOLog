//
//  TBOLoger.swift
//  Nimble-iOS
//
//  Created by TobyoTenma on 04/10/2017.
//

import Foundation

public struct TBOLog {
    private static var on = false
    public private(set) static var config: StartConfiguration = StartConfiguration()
    private static var isWorking: Bool {
        return on
    }
}

// MARK: - Start Loger

extension TBOLog {
    
    /// Start Log With Parameters
    ///
    /// - Parameters:
    ///   - level: Log Level, default: '.verbose'
    ///   - loggers: Work Loggers, default: 'ConsoleLogger.default'
    ///   - infoFlag: Log info flags, default: '.full'
    ///   - path: File Logger dictionary, default: 'TBOLog'
    ///   - isAsynchronously: Should asynchronously log, default: 'true'
    ///   - tag: The log tag string
    /// - Returns: Start result
    @discardableResult
    public static func start(
        _ level: Level = .verbose,
        loggers: [BaseLogger] = config.loggers,
        infoFlag: LogInfoFlag = .full,
        path: String = "TBOLog",
        isAsynchronously: Bool = config.isAsynchronously,
        tag: String? = nil) -> StartResult {
        config.level = level
        config.loggers = loggers
        config.flag = infoFlag
        config.path = path
        config.tag = tag
        config.isAsynchronously = isAsynchronously
        return start(config)
    }
    
    /// Start Log With Configuartions
    ///
    /// - Parameter configuration: Start configurations
    /// - Returns: Start result
    @discardableResult
    public static func start(_ configuration: StartConfiguration = config) -> StartResult {
        var result = StartResult(isSuccess: false, reason: nil)
        guard false == isWorking else {
            result.reason = "TBOLog Already Started"
            return result
        }
        LogInfo.prepareLogInfoDateFormat()
        config = configuration

        if var docURL = getDocumentURL() {
            docURL.appendPathComponent(config.path)
            try? FileManager.default.createDirectory(atPath: docURL.path, withIntermediateDirectories: true)
        }

        on = true
        result.isSuccess = on
        
        showStartInfo()
        return result
    }
    
    /// Stop Log, The Loggers will not work
    ///
    /// - Returns: Stop Result
    @discardableResult
    public static func stop() -> StartResult {
        var result = StartResult(isSuccess: false, reason: nil)
        guard true == isWorking else {
            result.reason = "TBOLog Already Stopped"
            return result
        }
        on = false
        result.isSuccess = on
        showStopInfo()
        return result
    }
}

// MARK: - Logger Operation

extension TBOLog {
    
    /// Add a Logger
    ///
    /// - Parameter logger: Can be `ASLLogger`, `ConsoleLogger` and `FileLogger`
    public static func append(logger: BaseLogger) {
        config.append(logger: logger)
    }

    /// Remove a Logger
    ///
    /// - Parameter logger: Can be `ASLLogger`, `ConsoleLogger` and `FileLogger`
    public static func remove(logger: BaseLogger) {
        config.remove(logger: logger)
    }
    
    /// Get an added logger
    ///
    /// - Parameter identifier: The logger identifier
    /// - Returns: The logger if has
    public static func logger(identifier: LoggerIdentifier) -> BaseLogger? {
        return config.logger(identifier: identifier.identifier)
    }
}

// MARK: - Output Log

extension TBOLog {
    
    /// Log with `.verbose` level
    ///
    /// - Parameters:
    ///   - contents: The content to log
    ///   - tag: The info tags
    ///   - loggers: The Loggers which should response the `contents`, default: `ConsoleLogger`
    ///   - flag: Log info flags, default: '.full'
    ///   - isAsynchronously: Should asynchronously log, default: 'true'
    ///   - file: Current file name
    ///   - line: The line number where the function called
    ///   - function: The function name where this function called
    public static func v(_ contents: Any...,
        tag: String? = config.tag,
        loggers: [LoggerIdentifier] = [config.defaultLogger.identifier],
        flag: LogInfoFlag = config.flag,
        isAsynchronously: Bool = config.isAsynchronously,
        file: String = #file,
        line: Int = #line,
        function: String = #function) {
        log(level:.verbose,
            contents: contents,
            tag: tag,
            loggers: loggers,
            flag: flag,
            isAsynchronously: isAsynchronously,
            file: file,
            line: line,
            function: function)
    }
    
    /// Log with `.debug` level
    ///
    /// - Parameters:
    ///   - contents: The content to log
    ///   - tag: The info tags
    ///   - loggers: The Loggers which should response the `contents`, default: `ConsoleLogger`
    ///   - flag: Log info flags, default: '.full'
    ///   - isAsynchronously: Should asynchronously log, default: 'true'
    ///   - file: Current file name
    ///   - line: The line number where the function called
    ///   - function: The function name where this function called
    public static func d(_ contents: Any...,
        tag: String? = config.tag,
        loggers: [LoggerIdentifier] = [config.defaultLogger.identifier],
        flag: LogInfoFlag = config.flag,
        isAsynchronously: Bool = config.isAsynchronously,
        file: String = #file,
        line: Int = #line,
        function: String = #function) {
        log(level:.debug,
            contents: contents,
            tag: tag,
            loggers: loggers,
            flag: flag,
            isAsynchronously: isAsynchronously,
            file: file,
            line: line,
            function: function)
    }
    
    /// Log with `.info` level
    ///
    /// - Parameters:
    ///   - contents: The content to log
    ///   - tag: The info tags
    ///   - loggers: The Loggers which should response the `contents`, default: `ConsoleLogger`
    ///   - flag: Log info flags, default: '.full'
    ///   - isAsynchronously: Should asynchronously log, default: 'true'
    ///   - file: Current file name
    ///   - line: The line number where the function called
    ///   - function: The function name where this function called
    public static func i(_ contents: Any...,
        tag: String? = config.tag,
        loggers: [LoggerIdentifier] = [config.defaultLogger.identifier],
        flag: LogInfoFlag = config.flag,
        isAsynchronously: Bool = config.isAsynchronously,
        file: String = #file,
        line: Int = #line,
        function: String = #function) {
        log(level:.info,
            contents: contents,
            tag: tag,
            loggers: loggers,
            flag: flag,
            isAsynchronously: isAsynchronously,
            file: file,
            line: line,
            function: function)
    }
    
    /// Log with `.warning` level
    ///
    /// - Parameters:
    ///   - contents: The content to log
    ///   - tag: The info tags
    ///   - loggers: The Loggers which should response the `contents`, default: `ConsoleLogger`
    ///   - flag: Log info flags, default: '.full'
    ///   - isAsynchronously: Should asynchronously log, default: 'true'
    ///   - file: Current file name
    ///   - line: The line number where the function called
    ///   - function: The function name where this function called
    public static func w(_ contents: Any...,
        tag: String? = config.tag,
        loggers: [LoggerIdentifier] = [config.defaultLogger.identifier],
        flag: LogInfoFlag = config.flag,
        isAsynchronously: Bool = config.isAsynchronously,
        file: String = #file,
        line: Int = #line,
        function: String = #function) {
        log(level:.warning,
            contents: contents,
            tag: tag,
            loggers: loggers,
            flag: flag,
            isAsynchronously: isAsynchronously,
            file: file,
            line: line,
            function: function)
    }
    
    /// Log with `.error` level
    ///
    /// - Parameters:
    ///   - contents: The content to log
    ///   - tag: The info tags
    ///   - loggers: The Loggers which should response the `contents`, default: `ConsoleLogger`
    ///   - flag: Log info flags, default: '.full'
    ///   - isAsynchronously: Should asynchronously log, default: 'true'
    ///   - file: Current file name
    ///   - line: The line number where the function called
    ///   - function: The function name where this function called
    public static func e(_ contents: Any...,
        tag: String? = config.tag,
        loggers: [LoggerIdentifier] = [config.defaultLogger.identifier],
        flag: LogInfoFlag = config.flag,
        isAsynchronously: Bool = config.isAsynchronously,
        file: String = #file,
        line: Int = #line,
        function: String = #function) {
        log(level:.error,
            contents: contents,
            tag: tag,
            loggers: loggers,
            flag: flag,
            isAsynchronously: isAsynchronously,
            file: file,
            line: line,
            function: function)
    }
}

// MARK: - Private Methods

// MARK: - Log
private extension TBOLog {
    static func log(level: Level,
                    contents: [Any],
                    tag: String?,
                    loggers: [LoggerIdentifier],
                    flag: LogInfoFlag,
                    isAsynchronously: Bool,
                    file: String = #file,
                    line: Int = #line,
                    function: String = #function) {
        guard true == isWorking,
            true == level.canWork else { return }

        guard false == loggers.isEmpty else {
            showNOLoggerInfo()
            return
        }
        
        let fileName: String
        if let lastComponent = URL(string: file)?.deletingPathExtension().lastPathComponent {
            fileName = lastComponent
        } else {
            fileName = String((file as NSString).lastPathComponent)
        }
        
        let info = LogInfo(level: level,
                           content: contents,
                           file: fileName,
                           line: line,
                           function: function,
                           tempInfoFlag: flag,
                           tag: tag)
        dispatchLog(info, to: loggers, isAsynchronously: isAsynchronously)
    }

    static func dispatchLog(_ info: LogInfo,
                     to loggers: [LoggerIdentifier],
                     isAsynchronously: Bool = TBOLog.config.isAsynchronously) {
        _ = loggers.map {
            logger(identifier: $0)?.flush(info, isAsynchronously: isAsynchronously)
        }
    }
}

// MARK: - Show Info

private extension TBOLog {
    
    static func showStartInfo() {
        let startInfo: String
        if let infoDict = Bundle(identifier: "org.cocoapods.TBOLog")?.infoDictionary,
            let version = infoDict["CFBundleShortVersionString"] {
            startInfo = "TBOLog Start Success! Version: " + String(describing: version)
                + " Level: " + config.level.description
                //+ " Destination: " + config.destination.description
        } else {
            startInfo = "TBOLog Start Success!"
        }
        show(startInfo)
    }
    
    static func showStopInfo() {
        let stopInfo = "TBOLog Stopped!"
        show(stopInfo)
    }
    
    static func showNOLoggerInfo() {
        let info = "Has not Destination!"
        show(info)
    }
    
    static func show(_ info: String) {
        i(info, flag: [.level, .threadName])
    }

    static func getDocumentURL() -> URL? {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first,
              let url = URL(string: path) else {
            assertionFailure("TBOLog Get DocumentDirectory Error!")
            return nil
        }
        return url
    }
}
