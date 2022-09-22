import Foundation

public struct Say: Fabula {
    public typealias Body = Never
    
    public init(_ text: String) {
        self.text = text
    }
    
    public let id: UUID = UUID()
    public let text: String
}

extension Say {
    public func run(in context: inout BotContext) async throws {
        try await context.bot.run(self)
    }
}

extension Say: Composable {
    public func accept(_ composer: Composer, parent: Node?) -> Node? {
        composer.compose(self, parent: parent)
    }
}
