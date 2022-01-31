import Foundation

/// An event emitted by a `FabulaBot`
public protocol FabulaEvent {
    var id: UUID { get }
    var type: String { get }
}

/// The list of supported `FabulaEvent`
public struct EventType {
    static let say: String = "event_say"
    static let ask: String = "event_ask"
    static let typing: String = "event_typing"
    static let empty: String = "event_empty"
    static let never: String = "event_never"
}


/// An event that does nothing
public struct EmptyEvent: FabulaEvent {
    public let id: UUID = .init()
    public let type: String = EventType.empty
}

/// The bot is typing or processing
public struct TypingEvent: FabulaEvent {
    public init() {}
    
    public let id: UUID = UUID()
    public let type: String = EventType.typing
}
