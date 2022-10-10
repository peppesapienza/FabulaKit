import Foundation

public struct Ask: Fabula, Suspendable, Presentable {
    public typealias Body = Never
    
    public var id: String { key }
    public let text: String
    
    /// The key associated to the user input
    public let key: String
    
    @FabulaState
    public var input: String = ""
    
    public let onSubmit: (String) async throws -> ()
}

extension Ask {
    public init(_ text: String, key: String) {
        self.text = text
        self.key = key
        self.onSubmit = { _ in }
    }
    
    public init(_ text: String, key: String, onSubmit: @escaping (String) async throws -> ()) {
        self.text = text
        self.key = key
        self.onSubmit = onSubmit
    }
}

extension Ask {
    public func onSubmit(_ action: @escaping (String) async throws -> ()) -> Ask {
        Ask(text, key: key, onSubmit: action)
    }
    
    public func submit<T>(_ input: T) async throws {
        guard let s = input as? String else { return }
        self.input = s
        try await onSubmit(s)
    }
}

extension Ask {
    public func run(in context: inout BotContext) async throws {
        context.bot.userProps.add(input: key, value: "")
        try await context.bot.present(self)
        try await context.bot.suspend(at: self)
    }
}

extension Ask: Composable {
    public func accept(_ composer: Composer, parent: Node?) -> Node? {
        composer.compose(self, parent: parent)
    }
}
