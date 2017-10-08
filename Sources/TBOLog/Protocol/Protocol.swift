//
//  Protocol.swift
//  Pods
//
//  Created by TobyoTenma on 08/10/2017.
//

import Foundation

extension OptionSet where Self == Self.Element {
    func check(_ destination: Self) -> Bool {
        return contains(destination)
    }
}
