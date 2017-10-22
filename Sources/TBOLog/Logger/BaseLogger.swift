//
//  BaseLogger.swift
//  Pods
//
//  Created by TobyoTenma on 14/10/2017.
//

import Foundation

class BaseLogger {
    
    func write(_ info: LogInfo) {
        precondition(false, "This Method Must Be Override!")
    }
    
}
