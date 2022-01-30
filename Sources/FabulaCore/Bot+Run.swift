extension FabulaBot {
    
    /// Enqueue and starts a `Conversation` script.
    public func run(_ conversation: Conversation) throws {
        let node = Node(conversation, parent: nil)
        TreeComposer().compose(conversation, parent: node)
        
        currentNode = node
        
        try run(node.content)
    }
    
    internal func run<T>(_ fabula: T) throws where T: Fabula {
        try run(fabula, with: BotContext(bot: self, input: ""))
    }
    
    internal func run<T>(_ fabula: T, with context: BotContext) throws where T: Fabula {
        guard !context.bot.isWaitingInput else {
            throw BotError.waitingUserInput
        }
        
        var context = context
        
        try fabula.run(in: &context)
    }
}
