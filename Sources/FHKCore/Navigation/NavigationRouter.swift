//
//  Router.swift
//  FHKCore
//
//  Created by Fredy Leon on 16/12/25.
//

import SwiftUI
import Foundation


// Observable navigation router
@MainActor
@Observable
public final class NavigationRouter<Destination: NavigationDestination> {
    public var path: [Destination] = []
    public var presentedDestination: Destination?
    public var presentationStyle: NavigationPresentationStyle = .push
    public var navigationBarItems: [NavigationBarItem] = []
    
    public init() {}
    
    /// Navigate to an observable destination
    public func navigate(to destination: Destination, style: NavigationPresentationStyle = .push) {
        switch style {
        case .push:
            path.append(destination)
            
        case .fullScreenCover, .sheet:
            presentationStyle = style
            presentedDestination = destination
        }
    }
    
    /// Navega hacia atrás
    public func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    /// Navega a un destino específico en el path (limpia el stack)
    public func popTo(_ destination: Destination) {
        guard let index = path.firstIndex(of: destination) else { return }
        path.removeSubrange((index + 1)...)
    }
    
    /// Go back to the root
    public func popToRoot() {
        path.removeAll()
    }
    
    /// Close the modal presentation
    public func dismiss() {
        presentedDestination = nil
    }
    
    /// Configure navigation bar items
    public func setNavigationBarItems(_ items: [NavigationBarItem]) {
        navigationBarItems = items
    }
    
    /// Clear items from the navigation bar
    public func clearNavigationBarItems() {
        navigationBarItems.removeAll()
    }
}

