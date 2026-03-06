//
//  ViewModel.swift
//  FHKCore
//
//  Created by Fredy Leon on 7/1/26.
//

import SwiftUI
import FHKDomain

public extension FHKCore {
    @MainActor
    protocol ViewModel {
        associatedtype Action: Equatable
        func action(_ action: Action) async
    }
}
public extension FHKCore.ViewModel {
    var nameAction: String {
        String(describing: Self.self) + ".Action"
    }
}
