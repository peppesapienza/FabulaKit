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
