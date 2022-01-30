import Foundation

/// An event emitted by a `FabulaBot`
public protocol FabulaEvent {
    var id: UUID { get }
}

/// An event that does nothing
public struct EmptyEvent: FabulaEvent {
    public let id: UUID = .init()
}
