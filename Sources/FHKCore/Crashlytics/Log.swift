//
//  Log.swift
//  FHKCore
//
//  Created by Fredy Leon on 8/2/26.
//

import Foundation

public struct Log: Equatable {
    public let error: Error
    public let attributes: LogAttributes?

    public init(error: Error, attributes: LogAttributes? = nil) {
        self.error = error
        self.attributes = attributes
    }

    public static func == (lhs: Log, rhs: Log) -> Bool {
        lhs.attributes == rhs.attributes
    }
}
