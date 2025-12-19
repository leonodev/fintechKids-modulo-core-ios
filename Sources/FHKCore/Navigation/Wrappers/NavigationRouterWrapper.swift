//
//  NavigationRouterWrapper.swift
//  FHKCore
//
//  Created by Fredy Leon on 19/12/25.
//

import Foundation
import SwiftUI

/// Property wrapper to access the NavigationRouter from the environment
@propertyWrapper
public struct NavigationRouterWrapper<Destination: NavigationDestination>: DynamicProperty {
    @Environment(\.navigationRouter) private var router
    
    public var wrappedValue: NavigationRouter<Destination> {
        guard let typedRouter = router as? NavigationRouter<Destination> else {
            fatalError("NavigationRouter not found in environment or type mismatch. Make sure you're using NavigationContainer.")
        }
        return typedRouter
    }
    
    public init() {}
}
