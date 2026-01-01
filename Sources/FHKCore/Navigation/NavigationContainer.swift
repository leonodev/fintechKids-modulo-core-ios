//
//  NavigationContainer.swift
//  FHKCore
//
//  Created by Fredy Leon on 19/12/25.
//

import Foundation
import SwiftUI

public struct NavigationContainer<Destination: NavigationDestination, Root: View>: View {
    //@State private var router: NavigationRouter<Destination>
    var router: NavigationRouter<Destination>
    private let rootView: Root
    
    public init(
        router: NavigationRouter<Destination>,
        @ViewBuilder root: () -> Root
    ) {
//        self._router = State(initialValue: router)
//        self.rootView = root()
        self.router = router
        self.rootView = root()
    }
    
    public var body: some View {
//        NavigationStack(path: $router.path) {
//            rootView
//                .navigationDestination(for: Destination.self) { destination in
//                    buildDestination(destination)
//                }
//        }
        @Bindable var bindableRouter = router
        
        NavigationStack(path: $bindableRouter.path) {
            rootView
                .navigationDestination(for: Destination.self) { destination in
                    buildDestination(destination)
                }
        }
        .fullScreenCover(item: Binding(
            get: { router.presentationStyle == .fullScreenCover ? router.presentedDestination : nil },
            set: { if $0 == nil { router.dismiss() } }
        )) { destination in
            ModalWrapper(destination: destination, router: router)
        }
        .sheet(item: Binding(
            get: { router.presentationStyle == .sheet ? router.presentedDestination : nil },
            set: { if $0 == nil { router.dismiss() } }
        )) { destination in
            ModalWrapper(destination: destination, router: router)
        }
        .environment(\.navigationRouter, router)
    }
    
    @ViewBuilder
    private func buildDestination(_ destination: Destination) -> some View {
        destination.view()
            .navigationTitle(destination.title ?? "")
            .navigationBarBackButtonHidden(destination.hidesNavigationBar)
            .toolbar {
                renderToolbarItems()
            }
    }

    @ToolbarContentBuilder
    private func renderToolbarItems() -> some ToolbarContent {
        ToolbarItemGroup(placement: .topBarLeading) {
            ForEach(router.navigationBarItems.filter { $0.placement == .leading }) { item in
                Button(action: { item.action() }) { Image(systemName: item.icon) }
            }
        }
        ToolbarItemGroup(placement: .topBarTrailing) {
            ForEach(router.navigationBarItems.filter { $0.placement == .trailing }) { item in
                Button(action: { item.action() }) { Image(systemName: item.icon) }
            }
        }
    }
}
