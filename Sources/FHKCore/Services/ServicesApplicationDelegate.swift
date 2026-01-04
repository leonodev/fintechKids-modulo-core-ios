//
//  ServicesApplicationDelegate.swift
//  FHKCore
//
//  Created by Fredy Leon on 2/1/26.
//

import UIKit

/// A protocol that defines a modular application service.
/// It inherits from `UIApplicationDelegate` and `UNUserNotificationCenterDelegate`
/// to allow services to react to both app lifecycle events and notification events.
@MainActor
public protocol ApplicationService: UIApplicationDelegate, UNUserNotificationCenterDelegate {}

/// A base class designed to de-clutter the `AppDelegate` by distributing responsibilities
/// across multiple independent services.
///
/// This class follows the **Composite Design Pattern**, delegating system events
/// to a collection of specialized service objects.
@MainActor
public class ServicesApplicationDelegate: UIResponder, UIApplicationDelegate {
    
    /// The list of services to be injected into the application lifecycle.
    /// Subclasses must override this property to provide specific services (e.g., Firebase, Analytics, Push).
    public var services: [ApplicationService] { [] }
    
    /// Internal lazy storage for the initialized services to ensure they are only created once.
    private lazy var servicesArray: [ApplicationService] = {
        return self.services
    }()

    // MARK: - App Lifecycle Management
    
    /// Forwards the app launch event to all registered services.
    /// - Parameters:
    ///   - application: The singleton app object.
    ///   - launchOptions: A dictionary indicating the reason the app was launched.
    /// - Returns: `true` if all services initialized successfully; otherwise, `false`.
    ///
    /// The result is calculated using a `reduce` operation: if any service returns `false`,
    /// the final result will be `false`, signaling a startup failure to the system.
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return servicesArray.reduce(true) { result, service in
            let serviceResult = service.application?(application, didFinishLaunchingWithOptions: launchOptions) ?? true
            return result && serviceResult
        }
    }

    // MARK: - Push Notification Registration
    
    /// Notifies all registered services that the app successfully registered with Apple Push Notification service (APNs).
    /// - Parameters:
    ///   - application: The singleton app object.
    ///   - deviceToken: A token that identifies the device to APNs.
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        servicesArray.forEach {
            $0.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        }
    }
    
    /// Notifies all registered services that the app failed to register with APNs.
    /// - Parameters:
    ///   - application: The singleton app object.
    ///   - error: An error object that encapsulates the reason for the failure.
    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        servicesArray.forEach {
            $0.application?(application, didFailToRegisterForRemoteNotificationsWithError: error)
        }
    }
}
