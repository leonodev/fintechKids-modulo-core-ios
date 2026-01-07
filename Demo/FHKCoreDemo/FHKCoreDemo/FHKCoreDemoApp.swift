//
//  FHKCoreDemoApp.swift
//  FHKCoreDemo
//
//  Created by Fredy Leon on 15/11/25.
//

import SwiftUI
import FHKCore

@main
struct FHKCoreDemoApp: App {
    @State private var appRouter = NavigationRouter<AuthRoute>()
    
    var body: some Scene {
        WindowGroup {
            NavigationContainer(router: appRouter) {
                ContentView()
            }
        }
    }
}
