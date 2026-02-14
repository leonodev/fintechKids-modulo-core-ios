//
//  CrashlyticsError.swift
//  FHKCore
//
//  Created by Fredy Leon on 8/2/26.
//
import Foundation
import FirebaseCrashlytics
import FHKUtils

public struct CrashlyticsError: Error, Equatable {
    public let log: Log
    
    public init(_ log: Log) {
        self.log = log
    }
    
    static public func send(_ log: Log) {
        // Enviamos el mensaje principal como un "breadcrumb"
        Crashlytics.crashlytics().log(log.message)
        
        // Si hay atributos, los añadimos como Custom Keys (son buscables en el dashboard)
        if let attributesDict = log.attributes?.dictionary {
            for (key, value) in attributesDict {
                Crashlytics.crashlytics().setCustomValue(value, forKey: key)
            }
        }
        
        // Si hay un error, lo registramos como un "Non-fatal error"
        if let error = log.error {
            Crashlytics.crashlytics().record(error: error)
        }
        
        // Debug local
#if DEBUG
        Logger.error("🚀 [CrashlyticsError] \(log.message) | Extras: \(log.attributes?.dictionary ?? [:])")
#endif
    }
}

