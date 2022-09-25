public protocol AnyFabulaBot: AnyObject {
    
    var userProps: UserProps { get }

    /// Enqueue and starts a `Conversation` script.
    func start(_ conversation: Conversation) async throws

    func reply(_ text: String) async
        
    func run(_ fabula: some Fabula) async throws
    
    func resume() async
}
