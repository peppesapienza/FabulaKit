public struct BotContext {
    public init(bot: AnyFabulaBot) {
        self.bot = bot
    }
    
    public var bot: AnyFabulaBot
    
    /// Injects the `bot.userInput` inside all matching tags `${some}`
    public func fill(_ text: String) -> String {
        Template(text).build(bot.userInput)
    }
}
