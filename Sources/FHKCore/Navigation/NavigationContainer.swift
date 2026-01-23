//
//  NavigationContainer.swift
//  FHKCore
//
//  Created by Fredy Leon on 19/12/25.
//

import Foundation
import SwiftUI
import FHKDesignSystem

public struct NavigationContainer<Destination: NavigationDestination, Root: View>: View {
    var router: NavigationRouter<Destination>
    private let rootView: Root
    
    public init(
        router: NavigationRouter<Destination>,
        @ViewBuilder root: () -> Root
    ) {
        self.router = router
        self.rootView = root()
        configureNavigationBarAppearance()
    }
    
    public var body: some View {
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

private func configureNavigationBarAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor.clear

    appearance.titleTextAttributes = [
        .foregroundColor: UIColor.white
    ]

    appearance.largeTitleTextAttributes = [
        .foregroundColor: UIColor.white
    ]

    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
}


public final class HostingController<Content: View>: UIHostingController<Content> {

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}


public struct HostingControllerWrapper: UIViewControllerRepresentable {
    
    public init() {}
    
    public func makeUIViewController(context: Context) -> UIViewController {
        HostingController(rootView: EmptyView())
    }

    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
