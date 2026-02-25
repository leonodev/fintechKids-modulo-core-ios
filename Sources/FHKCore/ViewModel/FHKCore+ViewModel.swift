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
    public var nameAction: String {
        String(describing: Self.self) + ".Action"
    }
}

public extension FHKCore {
    public enum State<T: Equatable>: Equatable {
        case loading
        case loaded
        case error(any FHKError)
        case finish(T?)
          
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
        
        public var isError: Bool {
            if case .error = self { return true }
            return false
        }
        
        public static func == (lhs: State<T>, rhs: State<T>) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading):
                return true
                
            case (.loaded, .loaded):
                return true
                
            case (.finish(let lVal), .finish(let rVal)):
                return lVal == rVal
                
            case (.error(let lErr), .error(let rErr)):
                return lErr.localizedDescription == rErr.localizedDescription
                
            default:
                return false
            }
        }
    }
}
