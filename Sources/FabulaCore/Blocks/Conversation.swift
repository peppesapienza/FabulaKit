public struct Conversation: Fabula, Container, Sequence {
    public typealias Body = Never
    public typealias Event = Never
    
    public let key: String
    public let children: [AnyFabula]
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
    public func makeIterator() -> FabulaIterator {
        let node = Node(self, parent: nil)
        TreeComposer().compose(self, parent: node)
        return FabulaIterator(node)
    }
}

extension Conversation: Composable {
    public func accept(_ composer: Composer, parent: Node) {
        composer.compose(self, parent: parent)
    }
}
