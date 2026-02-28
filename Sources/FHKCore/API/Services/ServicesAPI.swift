//
//  ServicesAPI.swift
//  FHKCore
//
//  Created by Fredy Leon on 12/12/25.
//

import Foundation
import FHKDomain

public final class FHKServicesAPI: FHKServicesAPIProtocol {
     let plistFileName = "ServicesAPI"
     let plistExtension = "plist"
    
    public init() {}
    
    public func getURL(environment: EnvironmentType,
                       country: Countries,
                       serviceKey: ServiceType) throws -> String {
        
        guard let url = Bundle.module.url(forResource: plistFileName, withExtension: plistExtension) else {
            throw APIConfigError.fileNotFound(name: "\(plistFileName).\(plistExtension)")
        }
        
        let data = try Data(contentsOf: url)
        
        // Deserialization Plist Root
        guard let rootDict = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] else {
            throw APIConfigError.deserializationFailed
        }
        
        // Search the  directory of environment (Production/Develop)
        guard let environmentDict = rootDict[environment.rawValue] as? [String: Any] else {
            throw APIConfigError.keyNotFound(key: environment.rawValue)
        }
        
        // Search the  directory by country (EN/FR/ES/IT)
        guard let languageDict = environmentDict[country.domain.uppercased()] as? [String: Any] else {
            throw APIConfigError.keyNotFound(key: "\(environment) -> \(country.domain)")
        }
        
        // Search the key of service
        guard let serviceURL = languageDict[serviceKey.rawValue] as? String else {
            throw APIConfigError.keyNotFound(key: "\(environment) -> \(country.domain) -> \(serviceKey)")
        }
        
        return serviceURL
    }
}
