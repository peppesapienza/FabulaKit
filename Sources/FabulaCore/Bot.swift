/// 
public protocol FabulaBot: AnyObject {
    var userInfo: [AnyHashable : Any] { get set }
    var userInput: [String : Any] { get set }
    
    var isWaitingInput: Bool { get }
    
    func enqueue(sequence: [AnyFabula]) throws
    
    func reply(_ text: String)
    
    func say(_ event: Say.Event)
    
    func ask(_ event: Ask.Event)
}

extension FabulaBot {
    internal(set) public var isWaitingInput: Bool {
        get { userInfo["isWaitingInput"] as? Bool ?? false }
        set { userInfo["isWaitingInput"] = newValue }
    }
    
    internal var currentNode: Node? {
        get { userInfo["_currentNode"] as? Node }
        set { userInfo["_currentNode"] = newValue }
    }
}
