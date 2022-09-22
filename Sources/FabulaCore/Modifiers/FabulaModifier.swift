import Foundation

public protocol FabulaModifier: Runnable {}

struct ModifiedFabula<Content, Modifier>: Fabula {
    typealias Body = Never
    
    let id: UUID = UUID()
    
    let content: Content
    let modifier: Modifier

    init(content: Content, modifier: Modifier) {
        self.content = content
        self.modifier = modifier
    }
    
    func run(in context: inout BotContext) async throws {
        try await (modifier as? Runnable)?.run(in: &context)
        try await (content as? Runnable)?.run(in: &context)
    }

}

extension ModifiedFabula: Composable {
    public func accept(_ composer: Composer, parent: Node?) -> Node? {
        composer.compose(self, parent: parent)
    }
}

