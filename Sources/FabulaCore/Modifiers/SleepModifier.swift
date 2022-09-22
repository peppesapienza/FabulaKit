import Foundation

struct SleepModifier: FabulaModifier {
    let seconds: TimeInterval
    
    func run(in context: inout BotContext) async throws {
        try await context.bot.run(Sleep(seconds))
    }
}

public extension Fabula {
    func sleep(_ seconds: TimeInterval) -> some Fabula {
        modifier(modifier: SleepModifier(seconds: seconds))
    }
}

