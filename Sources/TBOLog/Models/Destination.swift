//
//  Destination.swift
//  Pods
//
//  Created by TobyoTenma on 07/10/2017.
//

import Foundation

public struct Destination: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let console           = Destination(rawValue: 1 << 0)
    public static let file              = Destination(rawValue: 1 << 1)
    
    public static let all: Destination  = [.console, .file]
}
