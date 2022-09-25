import Foundation

public struct Conversation: Fabula, Container, Sequence {
    public typealias Body = Never
    
    public let id: UUID = UUID()
    public let key: String
    public var children: [any Fabula]
}

extension Conversation {
    public init(key: String, @FabulaBuilder _ content: () -> some Fabula) {
        self.init(
            key: key,
            children: (content() as? Container)?.children ?? [content()]
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
