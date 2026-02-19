// The Swift Programming Language
// https://docs.swift.org/swift-book

public enum FHKCore {}

public protocol FHKError: Error, Equatable {
    var logMessage: String { get }
    var isShouldTrack: Bool { get }
}

public extension FHKError {
    var isShouldTrack: Bool { true }
}
