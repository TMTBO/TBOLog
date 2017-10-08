//
//  TBOLoger.swift
//  Nimble-iOS
//
//  Created by TobyoTenma on 04/10/2017.
//

import Foundation

public enum TBOLog {
    private static var on = false
    public private(set) static var config: StartConfiguration = StartConfiguration()
    
    internal static let formatter = DateFormatter()
    
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
        infoTag: LogInfoTag = .full,
        path: String = "TBOLog",
        prefix: String? = nil) -> StartResult {
        config = StartConfiguration()
        config.level = level
        config.destination = destination
        config.infoTag = infoTag
        config.path = path
        config.prefix = prefix
        return start(config)
    }
    
    @discardableResult
    public static func start(_ configuration: StartConfiguration = config) -> StartResult {
        var result = StartResult(isSuccess: false, reason: nil)
        guard false == isWorking else {
            result.reason = "TBOLog Already Started"
            return result
        }
        prepareLog()
        
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
        return result
    }
}

extension TBOLog {
    public static func v(
        _ contents: Any...,
        destination: Destination = config.destination,
        infoTag: LogInfoTag = config.infoTag,
        prefix: String? = config.prefix,
        fileName: String = #file,
        line: Int = #line,
        funcName: String = #function) {
        log(
            level: .verbose,
            contents: contents,
            destination: destination,
            infoTag: infoTag,
            prefix: prefix,
            fileName: fileName,
            line: line,
            funcName: funcName)
    }
    
    public static func d(
        _ contents: Any...,
        destination: Destination = config.destination,
        infoTag: LogInfoTag = config.infoTag,
        prefix: String? = config.prefix,
        fileName: String = #file,
        line: Int = #line,
        funcName: String = #function) {
        log(
            level: .debug,
            contents: contents,
            destination: destination,
            infoTag: infoTag,
            prefix: prefix,
            fileName: fileName,
            line: line,
            funcName: funcName)
    }
    
    public static func i(
        _ contents: Any...,
        destination: Destination = config.destination,
        infoTag: LogInfoTag = config.infoTag,
        prefix: String? = config.prefix,
        fileName: String = #file,
        line: Int = #line,
        funcName: String = #function) {
        log(
            level: .info,
            contents: contents,
            destination: destination,
            infoTag: infoTag,
            prefix: prefix,
            fileName: fileName,
            line: line,
            funcName: funcName)
    }
    
    public static func w(
        _ contents: Any...,
        destination: Destination = config.destination,
        infoTag: LogInfoTag = config.infoTag,
        prefix: String? = config.prefix,
        fileName: String = #file,
        line: Int = #line,
        funcName: String = #function) {
        log(
            level: .warning,
            contents: contents,
            destination: destination,
            infoTag: infoTag,
            prefix: prefix,
            fileName: fileName,
            line: line,
            funcName: funcName)
    }
    
    public static func e(
        _ contents: Any...,
        destination: Destination = config.destination,
        infoTag: LogInfoTag = config.infoTag,
        prefix: String? = config.prefix,
        fileName: String = #file,
        line: Int = #line,
        funcName: String = #function) {
        log(
            level: .error,
            contents: contents,
            destination: destination,
            infoTag: infoTag,
            prefix: prefix,
            fileName: fileName,
            line: line,
            funcName: funcName)
    }
}

// MARK: - Private Log Methods

private extension TBOLog {
    static func log(
        level: Level,
        contents: [Any],
        destination: Destination,
        infoTag: LogInfoTag,
        prefix: String?,
        fileName: String = #file,
        line: Int = #line,
        funcName: String = #function) {
        guard true == isWorking else { return }
        
        if destination.contains(.console) {
            console(
                level: level,
                contents: contents,
                infoTag: infoTag,
                prefix: prefix,
                fileName: fileName,
                line: line,
                funcName: funcName)
        }
        if destination.contains(.file) {
            file(
                level: level,
                contents: contents,
                infoTag: infoTag,
                prefix: prefix,
                fileName: fileName,
                line: line,
                funcName: funcName)
        }
    }
    
    static func console(
        level: Level,
        contents: [Any],
        infoTag: LogInfoTag,
        prefix: String?,
        fileName: String = #file,
        line: Int = #line,
        funcName: String = #function) {
        let fileName = String((fileName as NSString)
            .lastPathComponent)
        let info = LogInfo(
            level: level,
            content: contents,
            fileName: fileName,
            line: line,
            funcName: funcName,
            tempInfoTag: infoTag,
            prefix: prefix)
        
        if let prefix = info.prefix,
            prefix.isEmpty == false {
            print(info.description, prefix, parseContent(info.content))
        } else {
            print(info.description, parseContent(info.content))
        }
    }
    
    static func file(
        level: Level,
        contents: [Any],
        infoTag: LogInfoTag,
        prefix: String?,
        fileName: String = #file,
        line: Int = #line,
        funcName: String = #function) {
        
    }
}

// MARK: - Private Parse Content Methods

private extension TBOLog {
    static func parseContent(_ content: [Any]) -> String {
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
    
    static func parseJsonContent(_ content: Any) -> String {
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
    
    static func parseNotJsonContent(_ content: Any) -> String {
        let contentString = String(describing: content)
        return contentString
    }
}

// MARK: - Private Methods

private extension TBOLog {
    static func prepareLog() {
        formatter.dateFormat = "YYYY/MM/dd/HH:mm:ss.SSS"
    }
    
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
        i(startInfo, destination: config.destination, infoTag: .level)
    }
}
