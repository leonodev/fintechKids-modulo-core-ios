//
//  Log.swift
//  FHKCore
//
//  Created by Fredy Leon on 8/2/26.
//

import Foundation

public struct Log: Equatable {
    public let message: String
    public let attributes: LogAttributes?
    public let error: Error?

    public init(message: String, attributes: LogAttributes? = nil, error: Error? = nil) {
        self.message = message
        self.attributes = attributes
        self.error = error
    }

    public static func == (lhs: Log, rhs: Log) -> Bool {
        lhs.message == rhs.message && lhs.attributes == rhs.attributes
    }
}


public struct LogAttributes: Equatable {
    public var screenName: String?
    public var platform: String = "iOS"
    public var userID: String?
    public var action: String?
    public var feature: String?
    
    // Default initializer
    public init(
        screenName: String? = nil,
        userID: String? = nil,
        action: String? = nil,
        feature: String? = nil
    ) {
        self.screenName = screenName
        self.userID = userID
        self.action = action
        self.feature = feature
    }
    
    /// Converts the struct into a dictionary for send.
    internal var dictionary: [String: Any] {
        var dict: [String: Any] = ["platform": platform]
        if let screenName = screenName { dict["screen_name"] = screenName }
        if let userID = userID { dict["user_id"] = userID }
        if let action = action { dict["action"] = action }
        if let feature = feature { dict["feature"] = feature }
        return dict
    }
}
