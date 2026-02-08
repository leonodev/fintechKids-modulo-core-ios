//
//  Log.swift
//  FHKCore
//
//  Created by Fredy Leon on 8/2/26.
//

import Foundation

public struct Log: Equatable {
    public let message: String
    public let attributes: [String: Any]?
    public let error: Error?

    public init(message: String, attributes: [String: Any]? = nil, error: Error? = nil) {
        self.message = message
        self.attributes = attributes
        self.error = error
    }

    public static func == (lhs: Log, rhs: Log) -> Bool {
        lhs.message == rhs.message
    }
}
