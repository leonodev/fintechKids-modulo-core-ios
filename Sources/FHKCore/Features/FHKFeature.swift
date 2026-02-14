//
//  Features.swift
//  FHKCore
//
//  Created by Fredy Leon on 14/2/26.
//

import Foundation

public enum FHKFeature: String, Equatable {
    case language
    case login
    case logout
    case register
    case forgotPassword
    case resetPassword
    case home
    case settings
    case members
    case unknown
    
    public var name: String {
        "\(self)"
    }
}
