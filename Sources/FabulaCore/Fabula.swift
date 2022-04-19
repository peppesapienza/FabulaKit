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

extension Fabula {
    internal func attribute(name: String, value: AnyValue) -> some Fabula {
        attribute(Attribute<Any>(
            name: name,
            value: value
        ))
   }

    internal func attribute<C>(_ attribute: Attribute<C>) -> some Fabula {
        if var modified = self as? ModifiedFabula {
            modified.attributes.append(attribute)
            return modified
        }
        
        return ModifiedFabula(self, attributes: [attribute])
    }
}


internal protocol Container {
    var children: [AnyFabula] { get set }
}

/// An helper extension to avoid accessing body of first level components
extension Never: Fabula, FabulaEvent {
    public typealias Event = Never

    public var body: Never { fatalError("no body in Never") }
    public var id: UUID { UUID() }
    public var type: String { EventType.never }
}

extension Fabula where Body == Never {
    public var body: Never { fatalError("no body in \(type(of: self))") }
}
