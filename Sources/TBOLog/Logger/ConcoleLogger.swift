//
//  ConcoleLogger.swift
//  Pods
//
//  Created by TobyoTenma on 14/10/2017.
//

import Foundation

class ConsoleLogger: BaseLogger {
    
    static let shared = ConsoleLogger()
    
    override private init() {
    }
    
    override func write(_ info: LogInfo) {
        print(info.description)
    }
}
