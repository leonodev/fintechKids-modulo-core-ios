//
//  NavigationRouterKey.swift
//  FHKCore
//
//  Created by Fredy Leon on 19/12/25.
//
import Foundation
import SwiftUI

// MARK: - Environment Key
private struct NavigationRouterKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue: Any? = nil
}

extension EnvironmentValues {
    var navigationRouter: Any? {
        get { self[NavigationRouterKey.self] }
        set { self[NavigationRouterKey.self] = newValue }
    }
}
