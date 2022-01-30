import Foundation

public struct Say: Fabula {
    public typealias Body = Never
    
    public init(_ text: String) {
        self.text = text
    }
    
    let text: String
}

extension Say {
    public func run(in context: inout BotContext) throws {
        context.bot.say(.init(
            text: context.fill(text)
        ))
    }
}

extension Say: Composable {
    public func accept(_ composer: Composer, parent: Node) {
        composer.compose(self, parent: parent)
    }
}


extension Say {
    public struct Event: FabulaEvent {
        public let id: UUID = .init()
        public let text: String
    }
}
