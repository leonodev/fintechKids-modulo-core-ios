//
//  DependenciesInjection.swift
//  FHKCore
//
//  Created by Fredy Leon on 29/12/25.
//

import SwiftUI
import Combine
import FHKStorage


// Store global thread-safe (solo KeyPath)
public final class DependenciesInjection: @unchecked Sendable {
public static let shared = DependenciesInjection()

private let lock = NSLock()
private var storage: [ObjectIdentifier: Any] = [:]

private init() {
    storage = [:]
}

// concrete types
public func get<T>(_ type: T.Type) -> T {
    lock.lock()
    defer { lock.unlock() }
    
    guard let value = storage[ObjectIdentifier(type)] as? T else {
        fatalError("Dependency is missing \(type)")
    }
    return value
}

public func set<T>(_ value: T, for type: T.Type) {
    lock.lock()
    storage[ObjectIdentifier(type)] = value
    lock.unlock()
}

// Scope temporal con snapshot/restore (ideal tests/flows)
public func withOverrides<R>(
    _ apply: (DependenciesInjection) -> Void,
    _ body: () throws -> R
) rethrows -> R {
    lock.lock()
    let snapshot = storage
    lock.unlock()
    
    apply(self)
    
    defer {
        lock.lock()
        storage = snapshot
        lock.unlock()
    }
    return try body()
}

    // Subscript para acceso con KeyPath (como tenías originalmente)
    public subscript<T: Sendable>(keyPath: KeyPath<DependenciesInjection, T>, type: T.Type) -> T {
        get { get(type) }
    }
    
    // Subscript para acceso directo por tipo
    public subscript<T: Sendable>(_ type: T.Type) -> T {
        get { get(type) }
        set { set(newValue, for: type) }
    }
    
    // check if it exists previously
    public func contains<T>(_ type: T.Type) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        return storage[ObjectIdentifier(type)] != nil
    }
}

// Property wrapper
@propertyWrapper
public struct Inject<T: Sendable> {
    private let keyPath: KeyPath<DependenciesInjection, T>
    private let type: T.Type
    
    public init(_ keyPath: KeyPath<DependenciesInjection, T>, _ type: T.Type = T.self) {
        self.keyPath = keyPath
        self.type = type
    }
    
    public var wrappedValue: T {
        DependenciesInjection.shared[keyPath, type]
    }
}


/*

EJEMPLO TEST

class LanguageManagerMock: LanguageManagerProtocol {
 // Al ser un Mock, podemos hacer que estas propiedades sean observables para el test
 var selectedLanguage: String = "en"
 var saveLanguageCalled = false
 var lastSavedLanguage: String?

 func readLanguage() async {
     // Simulamos una lectura exitosa
     self.selectedLanguage = "es"
 }

 func saveLanguage(_ language: String) async {
     saveLanguageCalled = true
     lastSavedLanguage = language
     self.selectedLanguage = language
 }
}



func test_cuando_se_guarda_idioma_el_viewmodel_actualiza_el_manager() async {
 let mock = LanguageManagerMock()
 
 // Usamos tu motor robusto para sobreescribir solo durante este bloque
 await Dependencies.shared.withOverrides({ deps in
     deps.set(mock, for: (any LanguageManagerProtocol).self)
 }) {
     // Dentro de este bloque, cualquier @Inject(\.languageManager) usará el 'mock'
     let viewModel = LanguageViewModel()
     
     await viewModel.saveLanguage("it")
     
     // Verificamos que el ViewModel llamó al método correcto del manager
     XCTAssertTrue(mock.saveLanguageCalled)
     XCTAssertEqual(mock.lastSavedLanguage, "it")
 }
 // Fuera de aquí, Dependencies.shared vuelve a tener el LanguageManager real
}


*/
