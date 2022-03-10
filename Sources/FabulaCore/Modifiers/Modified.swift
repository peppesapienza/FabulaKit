public struct ModifiedFabula {
    public let content: AnyFabula
    internal var attributes: [AnyAttribute]
    
    internal init<F>(_ fabula: F, attributes: [AnyAttribute]) where F: Fabula {
        self.content = fabula as? AnyFabula ?? AnyFabula(fabula)
        self.attributes = attributes
    }
}

extension ModifiedFabula {
    public func run(in context: inout BotContext) throws {
        
    }
}

extension ModifiedFabula: Composable {
    public func accept(_ composer: Composer, parent: Node?) -> Node? {
        composer.compose(self, parent: parent)
    }
}

extension ModifiedFabula: Fabula {
    public typealias Event = Never
    
    public var body: some Fabula {
        content
    }
}

import Foundation

extension Fabula {
    public func sleep(_ seconds: TimeInterval) -> ModifiedFabula {
        attribute(name: "sleep", value: .number(seconds))
    }
}
