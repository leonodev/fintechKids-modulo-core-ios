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
    protocol ViewModel {
        associatedtype Action: Equatable
        func action(_ action: Action) async
    }
}


public extension FHKCore {
    public enum State {
        case loading
        case loaded
        case error
          
        public var isLoading: Bool {
            if case .loading = self {
                return true
            }
            return false
        }
        
        public var isLoaded: Bool {
            if case .loaded = self {
                return true
            }
            return false
        }
    }
}
