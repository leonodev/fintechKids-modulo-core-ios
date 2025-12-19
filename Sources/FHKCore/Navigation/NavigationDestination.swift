//
//  NavigationDestination.swift
//  FHKCore
//
//  Created by Fredy Leon on 19/12/25.
//

import SwiftUI

/// Protocol that defines a navigation destination
public protocol NavigationDestination: Hashable, Identifiable, Sendable {
    associatedtype ContentView: View
    
    /// View associated with the destination
    @MainActor @ViewBuilder
    func view() -> ContentView
    
    /// Optional title for the navigation bar
    var title: String? { get }
    
    /// Indicates whether the view should hide the navigation bar
    var hidesNavigationBar: Bool { get }
}

// Default implementations
public extension NavigationDestination {
    var title: String? { nil }
    var hidesNavigationBar: Bool { false }
}
