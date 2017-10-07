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
    public var destination: Destination = .console
    public var infoTag: LogInfoTag = .full
    public var path: String = "TBOLog"
    public var prefix: String? = nil
}
