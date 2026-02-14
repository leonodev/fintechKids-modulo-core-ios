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
    
    // Default initializer
    public init(
        platform: Platform? = nil,
        userID: String? = nil,
        action: String? = nil,
        feature: FHKFeature? = nil
    ) {
        self.platform = platform
        self.userID = userID
        self.action = action
        self.feature = feature
    }
    
    /// Converts the struct into a dictionary for send.
    internal var dictionary: [String: Any] {
        var dict: [String: Any] = ["platform": platform?.name]
        if let userID = userID { dict["user_id"] = userID }
        if let action = action { dict["action"] = action }
        if let feature = feature { dict["feature"] = feature.name }
        return dict
    }
}

