public struct Say: Fabula {
    public typealias Body = Never
    
    init(_ text: String) {
        self.text = text
    }
    
    let text: String
}

extension Say {
    public func run(in context: inout BotContext) throws {
        context.bot.say(context.fill(text))
    }
}

extension Say: Composable {
    public func accept(_ composer: Composer, parent: Node) {
        composer.compose(self, parent: parent)
    }
}
