import Foundation

public struct BotError: Error, LocalizedError, CustomDebugStringConvertible {
    let key: String
    let message: String
    
    public var errorDescription: String? {
        key
    }
    
    public var failureReason: String? {
        message
    }
    
    public var debugDescription: String {
        """
        🤖🔥 \(key)
        \(message)
        """
    }
}

extension BotError: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.key == rhs.key
    }
}

extension BotError {
    static func templateKeyIsMissing(key: String, template: String) -> BotError {
        .init(key: "fabula_error_template_key_missing", message: """
         > FabulaBot can't fill the template key: ${\(key)}, in template: "\(template)"
        """)
    }
    
    static func alreadySuspended(at fabula: some Suspendable) -> BotError {
        .init(key: "fabula_error_bot_already_suspended", message: """
        > FabulaBot is already suspended at: \(fabula).
        > You should first resume your bot.
        """)
    }
}
