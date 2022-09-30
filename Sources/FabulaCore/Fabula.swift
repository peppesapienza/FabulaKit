import Foundation

public protocol Runnable {
    func run(in context: inout BotContext) async throws
}

/// A type that represents part of your conversation with a `FabulaBot`.
public protocol Fabula: Runnable, Composable {
    associatedtype Body: Fabula
    
    var id: UUID { get }
    
    @FabulaBuilder
    var body: Body { get }
}

extension Fabula {
    public func run(in context: inout BotContext) async throws {
        /// The base implementation does nothing.
    }
    
    @discardableResult
    public func accept(_ composer: Composer, parent: Node?) -> Node? {
        nil
    }
}

extension Fabula {
    public func modifier<Modifier>(modifier: Modifier) -> some Fabula {
        ModifiedFabula(content: self, modifier: modifier)
    }
}

public protocol Suspendable: Fabula {
    var key: String { get }
}

public protocol Container {
    var children: [any Fabula] { get set }
}

/// An helper extension to avoid accessing body of first level components
extension Never: Fabula {
    public func accept(_ composer: Composer, parent: Node?) -> Node? {
        fatalError("you can't add \(Never.self) into your fabula tree")
    }

    public var body: Never { fatalError("no body in \(Never.self)") }
    public var id: UUID { UUID() }
}

extension Fabula where Body == Never {
    public var body: Never { fatalError("no body in \(type(of: self))") }
}
