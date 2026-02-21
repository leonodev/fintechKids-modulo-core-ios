// The Swift Programming Language
// https://docs.swift.org/swift-book

public enum FHKCore {}

public protocol FHKError: Error, Equatable {
    var titleUI: String { get }
    var messageUI: String { get }
    var logMessage: String { get }
    var isShouldTrack: Bool { get }
}
