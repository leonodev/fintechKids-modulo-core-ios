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
    var body: some Scene {
        WindowGroup {
            NavigationContainer<AuthRoute, ContentView> {
                ContentView()
            }
        }
    }
}
