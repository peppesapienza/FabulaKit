/// A type-erased `Fabula`
public struct AnyFabula: Fabula {
    
    public typealias Body = Never
    public typealias Event = Never
    
    public init<F: Fabula>(_ fabula: F) {
        self.fabulaType = F.self
        self.value = fabula
        self.execute = fabula.run(in:)
    }
    
    let fabulaType: Any.Type
    let value: Any
    
    /// captures the underline fabula `run(in:)` action
    private var execute: (inout BotContext) throws -> Void
}

extension AnyFabula {
    public func run(in context: inout BotContext) throws {
        try execute(&context)
    }
}

extension AnyFabula: Composable {
    @discardableResult
    public func accept(_ composer: Composer, parent: Node?) -> Node? {
        composer.compose(self, parent: parent)
    }
}
