//
//  CachedData.swift
//  FHKCore
//
//  Created by Fredy Leon on 13/3/26.
//

import Foundation
import FHKDomain
import FHKInjections

public struct CachedData<T> {
    public let content: T
    public let timestamp: Date
    
    private var fhkFirebaseRemoteConfig: any FHKRemoteConfigManagerProtocol {
        inject.fhkFirebaseRemoteConfig
    }
    
    public init(content: T) {
        self.content = content
        self.timestamp = Date()
    }
    
    public func isExpired() async -> Bool {
        let timeExpirationConfig = await fhkFirebaseRemoteConfig.getCachedTimeExpiration()
        let expirationTime = Double(timeExpirationConfig * 60)
        return Date().timeIntervalSince(timestamp) > expirationTime
    }
}
