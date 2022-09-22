import Foundation

/// A type-erased `Fabula`
public struct AnyFabula: Fabula {
    
    public typealias Body = Never
    
    public init<F: Fabula>(_ fabula: F) {
        self.id = fabula.id
        self.fabulaType = F.self
        self.value = fabula
        self.execute = fabula.run(in:)
    }
    
    public let id: UUID
    public let fabulaType: Any.Type
    public let value: Any
    
    /// captures the underline fabula `run(in:)` action
    private var execute: (inout BotContext) async throws -> Void
}

extension AnyFabula {
    public func run(in context: inout BotContext) async throws {
        try await execute(&context)
    }
    
    func to<F>(fabula: F.Type) -> F? where F: Fabula {
        value as? F
    }
}

extension AnyFabula: Composable {
    @discardableResult
    public func accept(_ composer: Composer, parent: Node?) -> Node? {
        composer.compose(self, parent: parent)
    }
}
