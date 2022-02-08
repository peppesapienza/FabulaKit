extension AnyFabulaBot {
    internal func run<T>(_ fabula: T) throws where T: Fabula {
        try run(fabula, with: BotContext(bot: self, input: ""))
    }
    
    internal func run<T>(_ fabula: T, with context: BotContext) throws where T: Fabula {
        var context = context
        try fabula.run(in: &context)
    }
}
