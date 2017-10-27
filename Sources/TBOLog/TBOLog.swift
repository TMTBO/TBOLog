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
    private static let logQueue = DispatchQueue(label: "tbolog.logqueue")
    private static var isWorking: Bool {
        return on
    }
}

// MARK: - Public Methods

extension TBOLog {
    
    @discardableResult
    public static func start(
        _ level: Level,
        destination: Destination = .console,
        infoTag: LogInfoFlag = .full,
        path: String = "TBOLog",
        isAsynchronously: Bool = config.isAsynchronously,
        tag: String? = nil) -> StartResult {
        config = StartConfiguration()
        config.level = level
        config.destination = destination
        config.flag = infoTag
        config.path = path
        config.tag = tag
        config.isAsynchronously = isAsynchronously
        return start(config)
    }
    
    @discardableResult
    public static func start(_ configuration: StartConfiguration = config) -> StartResult {
        var result = StartResult(isSuccess: false, reason: nil)
        guard false == isWorking else {
            result.reason = "TBOLog Already Started"
            return result
        }
        LogInfo.prepareLogInfoDateFormat()
        
        guard let basePath = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .userDomainMask,
            true).first,
            var logPath = URL(string: basePath) else {
                fatalError("Start TBOLog failed, reason: Can not find user document directory")
        }
        logPath.appendPathComponent(configuration.path)
        
        config = configuration
        
        on = true
        result.isSuccess = on
        
        showStartInfo()
        return result
    }
    
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

extension TBOLog {
    public static func v(_ contents: Any...,
        tag: String? = config.tag,
        destination: Destination = config.destination,
        flag: LogInfoFlag = config.flag,
        isAsynchronously: Bool = config.isAsynchronously,
        file: String = #file,
        line: Int = #line,
        function: String = #function) {
        log(level:.verbose,
            contents: contents,
            tag: tag,
            destination: destination,
            flag: flag,
            isAsynchronously: isAsynchronously,
            file: file,
            line: line,
            function: function)
    }
    
    public static func d(_ contents: Any...,
        tag: String? = config.tag,
        destination: Destination = config.destination,
        flag: LogInfoFlag = config.flag,
        isAsynchronously: Bool = config.isAsynchronously,
        file: String = #file,
        line: Int = #line,
        function: String = #function) {
        log(level:.debug,
            contents: contents,
            tag: tag,
            destination: destination,
            flag: flag,
            isAsynchronously: isAsynchronously,
            file: file,
            line: line,
            function: function)
    }
    
    public static func i(_ contents: Any...,
        tag: String? = config.tag,
        destination: Destination = config.destination,
        flag: LogInfoFlag = config.flag,
        isAsynchronously: Bool = config.isAsynchronously,
        file: String = #file,
        line: Int = #line,
        function: String = #function) {
        log(level:.info,
            contents: contents,
            tag: tag,
            destination: destination,
            flag: flag,
            isAsynchronously: isAsynchronously,
            file: file,
            line: line,
            function: function)
    }
    public static func w(_ contents: Any...,
        tag: String? = config.tag,
        destination: Destination = config.destination,
        flag: LogInfoFlag = config.flag,
        isAsynchronously: Bool = config.isAsynchronously,
        file: String = #file,
        line: Int = #line,
        function: String = #function) {
        log(level:.warning,
            contents: contents,
            tag: tag,
            destination: destination,
            flag: flag,
            isAsynchronously: isAsynchronously,
            file: file,
            line: line,
            function: function)
    }
    public static func e(_ contents: Any...,
        tag: String? = config.tag,
        destination: Destination = config.destination,
        flag: LogInfoFlag = config.flag,
        isAsynchronously: Bool = config.isAsynchronously,
        file: String = #file,
        line: Int = #line,
        function: String = #function) {
        log(level:.error,
            contents: contents,
            tag: tag,
            destination: destination,
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
                    destination: Destination,
                    flag: LogInfoFlag,
                    isAsynchronously: Bool,
                    file: String = #file,
                    line: Int = #line,
                    function: String = #function) {
        guard true == isWorking,
            true == level.canWork else { return }
        
        let loggers = destination.getLoggers()
        guard false == loggers.isEmpty else {
            showNOLoggerInfo()
            return
        }
        
        let fileName = String((file as NSString)
            .lastPathComponent)
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
                            to loggers: [BaseLogger],
                            isAsynchronously: Bool = config.isAsynchronously) {
        let workItem = DispatchWorkItem {
            _ = loggers.map { $0.write(_: info) }
        }
        if isAsynchronously {
            logQueue.async(execute: workItem)
        } else {
            logQueue.sync(execute: workItem)
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
                + " Destination: " + config.destination.description
        } else {
            startInfo = "TBOLog Start Success!"
        }
        show(startInfo)
    }
    
    static func showStopInfo() {
        let stopInfo = "TBOLog Stoped!"
        show(stopInfo)
    }
    
    static func showNOLoggerInfo() {
        let info = "Has not Destination!"
        show(info)
    }
    
    static func show(_ info: String) {
        i(info, flag: [.level, .threadName])
    }
}


