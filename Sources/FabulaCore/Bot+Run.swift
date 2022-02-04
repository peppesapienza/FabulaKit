extension FabulaBot {
    
    /// Enqueue and starts a `Conversation` script.
    public func start(_ conversation: Conversation) throws {
        try enqueue(conversation.makeIterator())
    }
    
    internal func run<T>(_ fabula: T) throws where T: Fabula {
        try run(fabula, with: BotContext(bot: self, input: ""))
    }
    
    internal func run<T>(_ fabula: T, with context: BotContext) throws where T: Fabula {
        var context = context
        try fabula.run(in: &context)
    }
}
