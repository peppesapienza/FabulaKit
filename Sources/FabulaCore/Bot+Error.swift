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

public extension BotError {
    static let waitingUserInput: BotError = .init(key: "fabula_error_waiting_user_input", message: "FabulaBot is waiting for an user input.")
}


