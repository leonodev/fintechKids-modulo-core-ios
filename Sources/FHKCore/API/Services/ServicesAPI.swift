//
//  ServicesAPI.swift
//  FHKCore
//
//  Created by Fredy Leon on 12/12/25.
//

import Foundation
import FHKConfig

public enum APIConfigError: Error {
    case fileNotFound(name: String)
    case deserializationFailed
    case keyNotFound(key: String)
    case invalidType
}

public enum ServiceType : String {
    case supabase = "supabase"
}

public struct ServicesAPI {
    private static let plistFileName = "ServicesAPI"
    private static let plistExtension = "plist"
    
    public static func getURL(environment: Configuration.EnvironmentType = Configuration.getEnvironment(),
                              language: Configuration.LanguageType = Configuration.getLanguage(),
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
        
        // Search the  directory of language (EN/FR/ES/IT)
        guard let languageDict = environmentDict[language.rawValue.uppercased()] as? [String: Any] else {
            throw APIConfigError.keyNotFound(key: "\(environment) -> \(language)")
        }
        
        // Search the key of service
        guard let serviceURL = languageDict[serviceKey.rawValue] as? String else {
            throw APIConfigError.keyNotFound(key: "\(environment) -> \(language) -> \(serviceKey)")
        }
        
        return serviceURL
    }
}
