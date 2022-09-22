public struct BotContext {
    public init(bot: AnyFabulaBot) {
        self.bot = bot
    }
    
    public var bot: AnyFabulaBot
}
