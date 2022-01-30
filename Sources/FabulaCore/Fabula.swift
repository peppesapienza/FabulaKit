import Foundation

/// A type that represents part of your conversation with a`FabulaBot`.
///
public protocol Fabula {
    associatedtype Body: Fabula
    associatedtype Event: FabulaEvent
    
    @FabulaBuilder
    var body: Body { get }
        
    func run(in context: inout BotContext) throws
}

extension Fabula {
    public func run(in context: inout BotContext) throws {
        /// The base implementation does nothing.
    }
}



public protocol Container {
    var children: [AnyFabula] { get }
}

/// An helper extension to avoid accessing body of first level components
extension Never: Fabula, FabulaEvent {
    public typealias Event = Never

    public var body: Never { fatalError("no body in Never") }
    public var id: UUID { UUID() }
}

extension Fabula where Body == Never {
    public var body: Never { fatalError("no body in \(type(of: self))") }
}
