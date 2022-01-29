public struct Ask: Fabula {
    
    public typealias Body = Never
    
    let text: String
    
    /// The key associated to the user input
    let key: String
}

public extension Ask {
    init(_ text: String, key: String) {
        self.text = text
        self.key = key
    }
}

extension Ask {
    public func run(in context: inout BotContext) throws {
        context.bot.userInput[key] = ""
        context.bot.ask(context.fill(text))
    }
}

extension Ask: Composable {
    public func accept(_ composer: Composer, parent: Node) {
        composer.compose(self, parent: parent)
    }
}
