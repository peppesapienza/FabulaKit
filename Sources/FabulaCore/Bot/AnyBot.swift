/// 
public protocol AnyFabulaBot: AnyObject {
    var userInfo: [AnyHashable : Any] { get set }
    var userInput: [String : Any] { get set }
    
    /// Enqueue and starts a `Conversation` script.
    func start(_ conversation: Conversation) throws

    func reply(_ text: String)
    
    func schedule(_ event: FabulaEvent)
    
    func resume()
}
