import Foundation

public struct Conversation: Fabula, Container, Sequence {
    public typealias Body = Never
    public typealias Event = Never
    
    public let id: UUID = UUID()
    public let key: String
    public var children: [AnyFabula]
}

extension Conversation {
    public init<C>(key: String, @FabulaBuilder _ content: () -> C) where C: Fabula {
        self.init(
            key: key,
            children: (content() as? Container)?.children ?? [AnyFabula(content())]
        )
    }
}

extension Conversation {
    public func run(in context: inout BotContext) async throws {
        await context.bot.resume()
    }
    
    public func makeIterator() -> FabulaIterator {
        FabulaIterator(TreeComposer().compose(self, parent: nil)!)
    }
}

extension Conversation: Composable {
    public func accept(_ composer: Composer, parent: Node?) -> Node? {
        composer.compose(self, parent: parent)
    }
}
