//
//  LogAttributes.swift
//  FHKCore
//
//  Created by Fredy Leon on 14/2/26.
//

import Foundation

protocol LogAttributesProtocol: Equatable {
    associatedtype Action: Equatable
}

public struct LogAttributes: LogAttributesProtocol {
    public enum Action: Equatable {
        
        public var name: String {
            "\(self)"
        }
    }
    
    public enum Platform: String, Equatable {
        case iOS
        case watchOS
        case macOS
        case tvOS
        
        public var name: String {
            "\(self)"
        }
    }
    
    public var platform: Platform?
    public var userID: String?
    public var action: String?
    public var feature: FHKFeature?
    public var extraInfo: [String: Any]?
    
    // Default initializer
    public init(
        platform: Platform? = nil,
        userID: String? = nil,
        action: String? = nil,
        feature: FHKFeature? = nil,
        extraInfo: [String: Any]? = nil
    ) {
        self.platform = platform
        self.userID = userID
        self.action = action
        self.feature = feature
        self.extraInfo = extraInfo
    }
    
    public static func == (lhs: LogAttributes, rhs: LogAttributes) -> Bool {
        return lhs.userID == rhs.userID &&
        lhs.action == rhs.action &&
        lhs.platform == rhs.platform
    }
    
    /// Converts the struct into a dictionary for send.
    internal var dictionary: [String: Any] {
        var dict: [String: Any] = ["platform": platform?.name]
        if let userID = userID { dict["user_id"] = userID }
        if let action = action { dict["action"] = action }
        if let feature = feature { dict["feature"] = feature.name }
        
        if let extraInfo = extraInfo {
            // merge avoids collisions or allows the extra to overwrite values ​​if you want
            dict.merge(extraInfo) { (current, _) in current }
        }
        
        return dict
    }
}

