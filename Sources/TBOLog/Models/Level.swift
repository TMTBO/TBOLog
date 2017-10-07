//
//  Level.swift
//  Pods
//
//  Created by TobyoTenma on 07/10/2017.
//

import Foundation

public enum Level: UInt {
    case verbose
    case debug
    case info
    case warning
    case error
    case none
    
    var description: String {
        switch self {
        case .verbose:
            return "Verbose"
        case .debug:
            return "Debug"
        case .info:
            return "Info"
        case .warning:
            return "Warning"
        case .error:
            return "Error"
        case .none:
            return "None"
        }
    }
}
