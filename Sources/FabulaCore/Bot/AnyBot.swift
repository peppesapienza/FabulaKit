public protocol AnyFabulaBot: AnyObject {
    
    var userProps: UserProps { get }

    /// Enqueue and starts a `Conversation` script.
    func start(_ conversation: Conversation) async throws

    func reply(_ text: String) async
        
    func present(_ fabula: some Presentable) async throws
    
    func resume() async
    func suspend(at fabula: some Suspendable) async throws
}
