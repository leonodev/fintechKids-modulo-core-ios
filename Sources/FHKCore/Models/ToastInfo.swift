//
//  ToastInfo.swift
//  FHKCore
//
//  Created by Fredy Leon on 2/3/26.
//

public enum ToastType {
    case success
    case error
    case warning
    case notification
}

public class FHKToastInfo {
    public var type: ToastType
    public var message: String
    public var hasIcon: Bool
    
    public init(type: ToastType = .success, message: String = "", hasIcon: Bool = false) {
        self.type = type
        self.message = message
        self.hasIcon = hasIcon
    }
}
