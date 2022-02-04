import Foundation

public struct Ask: Fabula {
    public typealias Body = Never
    
    public init(_ text: String, key: String) {
        self.text = text
        self.key = key
    }
    
    let text: String
    
    /// The key associated to the user input
    let key: String
}

extension Ask {
    public func run(in context: inout BotContext) throws {
        context.bot.userInput[key] = ""
        context.bot.ask(Ask.Event(
            text: context.fill(text),
            key: key
        ))
    }
}

extension Ask: Composable {
    public func accept(_ composer: Composer, parent: Node) {
        composer.compose(self, parent: parent)
    }
}

extension Ask {
    public struct Event: FabulaEvent {
        public init(text: String, key: String) {
            assert(!key.isEmpty, "requires a non-empty key")
            self.key = key
            self.text = text
        }
        
        public let id: UUID = .init()
        public let type: String = EventType.ask
        
        public let text: String
        public let key: String
    }
}
