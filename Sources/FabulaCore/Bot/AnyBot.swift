public protocol AnyFabulaBot: AnyObject {
    
    var userProps: UserProps { get }

    /// Enqueue and starts a `Conversation` script.
    func start(_ conversation: Conversation) async throws

    func reply(_ text: String) async
        
    func run<F>(_ fabula: F) async throws where F: Fabula
    
    func resume() async
}
