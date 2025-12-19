//
//  FHKCore.swift
//  FHKCore
//
//  Created by FHK on 2025/12/18.
//

import SwiftUI
import Combine

// MARK: - AppRoute Protocol

/// Protocol for defining navigation routes.
public protocol AppRoute: Hashable, Identifiable where ID == String {
    associatedtype Destination: View
    var id: String { get }
    @ViewBuilder func destination() -> Destination
}

extension AppRoute {
    public var id: String {
        String(describing: self)
    }
}

// MARK: - AnyRoute (Type Erasure)

/// Type-erased route to be used in NavigationPath.
public struct AnyRoute: Hashable, Identifiable {
    public let id: String
    private let _hash: (inout Hasher) -> Void
    private let _equals: (AnyRoute) -> Bool
    private let _destination: () -> AnyView

    public init<R: AppRoute>(_ route: R) {
        self.id = route.id
        self._hash = { hasher in hasher.combine(route) }
        self._equals = { other in
            guard let otherRoute = other.base as? R else { return false }
            return route == otherRoute
        }
        self._destination = { AnyView(route.destination()) }
        self.base = route
    }

    private let base: Any

    public func hash(into hasher: inout Hasher) {
        _hash(&hasher)
    }

    public static func ==(lhs: AnyRoute, rhs: AnyRoute) -> Bool {
        lhs._equals(rhs)
    }

    /// Returns the associated destination view.
    @ViewBuilder
    public func destination() -> some View {
        _destination()
    }
}

// MARK: - NavigationMode

/// Defines navigation style.
public enum NavigationMode: Equatable {
    public struct SheetConfig: Equatable {
        public var detents: [UISheetPresentationController.Detent]
        public init(detents: [UISheetPresentationController.Detent]) {
            self.detents = detents
        }

        public static let medium = SheetConfig(detents: [.medium()])
        public static let large = SheetConfig(detents: [.large()])
        public static let custom = SheetConfig(detents: [])
    }

    case push
    case sheet(SheetConfig)
    case fullScreenCover
}

// MARK: - NavigationContext

/// Provides context about navigation event.
public struct NavigationContext {
    public let from: AnyRoute?
    public let mode: NavigationMode
    public let parameters: [String: Any]

    public init(from: AnyRoute?, mode: NavigationMode, parameters: [String: Any] = [:]) {
        self.from = from
        self.mode = mode
        self.parameters = parameters
    }
}

// MARK: - Router

/// Main navigation router managing navigation state.
@MainActor
public class Router: ObservableObject {
    /// Navigation path stack for push navigation.
    @Published private(set) var path = NavigationPath()

    /// Currently presented modal route if any.
    @Published private(set) var presentedRoute: (route: AnyRoute, mode: NavigationMode)? = nil

    /// Handlers to execute on navigation.
    private var routeHandlers: [(AnyRoute, NavigationContext) -> Void] = []

    /// Mapping route id to whether to clear to root on back.
    private var clearToRootOnBackMap: Set<String> = []

    public init() {}

    /// Navigate to a route.
    ///
    /// - Parameters:
    ///   - route: The route to navigate to.
    ///   - mode: Navigation mode (default `.push`).
    ///   - parameters: Optional parameters to pass.
    public func navigate<R: AppRoute>(
        to route: R,
        mode: NavigationMode = .push,
        parameters: [String: Any] = [:]
    ) {
        let anyRoute = AnyRoute(route)
        let context = NavigationContext(from: currentlyPresentedRoute(), mode: mode, parameters: parameters)

        switch mode {
        case .push:
            path.append(anyRoute)
        case .sheet, .fullScreenCover:
            presentedRoute = (anyRoute, mode)
        }

        executeHandlers(route: anyRoute, context: context)
    }

    /// Navigate back (pop one route or dismiss modal).
    public func navigateBack() {
        if presentedRoute != nil {
            dismissModal()
        } else if !path.isEmpty {
            if let last = path.last as? AnyRoute,
               clearToRootOnBackMap.contains(last.id) {
                popToRoot()
            } else {
                path.removeLast()
            }
        }
    }

    /// Pop to root of the navigation stack.
    public func popToRoot() {
        path.removeLast(path.count)
    }

    /// Pop to a specific route instance in the path.
    public func popTo<R: AppRoute>(_ route: R) {
        let anyRoute = AnyRoute(route)
        guard let index = path.elements.firstIndex(where: {
            guard let er = $0 as? AnyRoute else { return false }
            return er == anyRoute
        }) else { return }
        let countToRemove = path.count - index - 1
        if countToRemove > 0 {
            path.removeLast(countToRemove)
        }
    }

    /// Set routes for which the back action clears to root.
    public func clearToRootOnBack(from routeID: String) {
        clearToRootOnBackMap.insert(routeID)
    }

    /// Register a route navigation handler for side effects.
    public func registerRouteHandler<R: AppRoute>(
        for _: R.Type,
        handler: @escaping (R, NavigationContext) -> Void
    ) {
        routeHandlers.append { anyRoute, context in
            if let route = anyRoute.base as? R {
                handler(route, context)
            }
        }
    }

    /// Dismiss any presented modal.
    public func dismissModal() {
        presentedRoute = nil
    }

    /// Return the currently presented route (top-most modal or nil).
    private func currentlyPresentedRoute() -> AnyRoute? {
        if let presented = presentedRoute {
            return presented.route
        }
        if let last = path.elements.last as? AnyRoute {
            return last
        }
        return nil
    }

    /// Executes all registered route handlers.
    private func executeHandlers(route: AnyRoute, context: NavigationContext) {
        for handler in routeHandlers {
            handler(route, context)
        }
    }
}

// MARK: - NavigationRouter Property Wrapper

/// Property wrapper to access shared Router instance.
@propertyWrapper
@MainActor
public struct NavigationRouter: DynamicProperty {
    @EnvironmentObject private var router: Router

    public init() {}

    public var wrappedValue: Router {
        router
    }
}

// MARK: - NavigationRootView

/// Root container integrating Router into NavigationStack and modal presentation.
public struct NavigationRootView<Content: View>: View {
    @StateObject private var router = Router()
    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        NavigationStack(path: $router.path) {
            content
                .environmentObject(router)
                .navigationDestination(for: AnyRoute.self) { route in
                    route.destination()
                        .navigationBarBackButtonHidden(false)
                }
                .sheet(item: Binding(
                    get: { router.presentedRoute?.mode.isSheet == true ? router.presentedRoute?.route : nil },
                    set: { _ in router.dismissModal() })
                ) { route in
                    NavigationModalWrapper(route: route, router: router)
                }
                .fullScreenCover(item: Binding(
                    get: { router.presentedRoute?.mode == .fullScreenCover ? router.presentedRoute?.route : nil },
                    set: { _ in router.dismissModal() })
                ) { route in
                    NavigationModalWrapper(route: route, router: router)
                }
        }
    }
}

// Helper to wrap modal destination with close button
private struct NavigationModalWrapper: View {
    let route: AnyRoute
    @ObservedObject var router: Router

    var body: some View {
        NavigationView {
            route.destination()
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            router.dismissModal()
                        }) {
                            Image(systemName: "xmark")
                        }
                        .accessibilityLabel("Close")
                    }
                }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - NaviBarItem & NavigationBar Modifier

/// Item to add to navigation bar.
public struct NaviBarItem: Identifiable {
    public let id = UUID()
    public let icon: IconType
    public let action: () -> Void

    public enum IconType {
        case system(name: String)
        case image(Image)
    }

    public init(icon: IconType, action: @escaping () -> Void) {
        self.icon = icon
        self.action = action
    }
}

public struct NavigationBar: ViewModifier {
    let title: String
    let leadingItems: [NaviBarItem]
    let trailingItems: [NaviBarItem]

    public func body(content: Content) -> some View {
        content
            .navigationTitle(title)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    ForEach(leadingItems) { item in
                        Button(action: item.action) {
                            navBarIcon(item.icon)
                        }
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    ForEach(trailingItems) { item in
                        Button(action: item.action) {
                            navBarIcon(item.icon)
                        }
                    }
                }
            }
    }

    @ViewBuilder
    private func navBarIcon(_ icon: NaviBarItem.IconType) -> some View {
        switch icon {
        case .system(let name):
            Image(systemName: name)
        case .image(let image):
            image
        }
    }
}

public extension View {
    func navigationBar(
        title: String,
        leadingItems: [NaviBarItem] = [],
        trailingItems: [NaviBarItem] = []
    ) -> some View {
        modifier(NavigationBar(title: title, leadingItems: leadingItems, trailingItems: trailingItems))
    }
}

// MARK: - NavigationMode Extensions

private extension NavigationMode {
    var isSheet: Bool {
        if case .sheet = self { return true }
        return false
    }
}

// MARK: - View Extension for injecting Router

public extension View {
    /// Inject a fresh Router in the view hierarchy.
    func withNavigationRouter() -> some View {
        self.environmentObject(Router())
    }
}
