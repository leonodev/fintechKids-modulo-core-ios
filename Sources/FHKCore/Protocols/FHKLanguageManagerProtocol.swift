//
//  FHKLanguageManagerProtocol.swift
//  FHKCore
//
//  Created by Fredy Leon on 22/2/26.
//

import FHKInjections
import FHKConfig

public protocol FHKLanguageManagerProtocol: FHKInjectableProtocol {
    var selectedLanguage: String { get set }
    var currentBundle: Bundle { get }
    func changeLanguage(to language: String)
    func languageTypeFromCode(_ string: String) -> LanguageType
}
