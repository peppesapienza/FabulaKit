/// 
public protocol FabulaBot: AnyObject {
    var userInfo: [AnyHashable : Any] { get set }
    var userInput: [String : Any] { get set }
    
    func enqueue(_ iterator: FabulaIterator) throws

    func reply(_ text: String)
    
    func say(_ event: Say.Event)
    
    func ask(_ event: Ask.Event)
    
    func resume()
}
