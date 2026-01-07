//
//  ViewModel.swift
//  FHKCore
//
//  Created by Fredy Leon on 7/1/26.
//

import SwiftUI
import Combine

public extension FHKCore {
    @MainActor
    protocol ViewModel: ObservableObject {
        associatedtype Action: Equatable
        func action(_ action: Action) async
    }
}
