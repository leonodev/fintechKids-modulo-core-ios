//
//  ToastProtocol.swift
//  FHKCore
//
//  Created by Fredy Leon on 2/3/26.
//

@MainActor
public protocol FHKToastProtocol: Sendable {
    var currentToast: FHKToastInfo? { get set }
    var isVisible: Bool { get set }
    func show(info: FHKToastInfo, duration: Double)
    func dismiss()
}
