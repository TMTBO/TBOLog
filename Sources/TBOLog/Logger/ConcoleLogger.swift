//
//  ConcoleLogger.swift
//  Pods
//
//  Created by TobyoTenma on 14/10/2017.
//

import Foundation

public class ConsoleLogger: QueueLogger {
    
    public static let `default` = ConsoleLogger()

    override
    init(identifier: String = "default-console-logger") {
        super.init(identifier: identifier)
    }

    override func write(_ info: LogInfo) {
        print(info.description)
    }
}
