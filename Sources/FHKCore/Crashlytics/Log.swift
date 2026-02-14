//
//  Log.swift
//  FHKCore
//
//  Created by Fredy Leon on 8/2/26.
//

import Foundation

public struct Log: Equatable {
    public let attributes: LogAttributes?
    public let error: Error

    public init(attributes: LogAttributes? = nil, error: Error) {
        self.attributes = attributes
        self.error = error
    }

    public static func == (lhs: Log, rhs: Log) -> Bool {
        lhs.attributes == rhs.attributes
    }
}
