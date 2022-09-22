import Combine

public class UserProps: ObservableObject {
    
    public init() {}
    
    @Published
    private(set) public var info: [AnyHashable : Any] = [:]
    
    @Published
    private(set) public var inputs: [String : Any] = [:]
    
    func add(input key: String, value: Any) {
        inputs[key] = value
    }
    
    /// Injects the `inputs` inside all matching tags `${some}`
    public func enrich(_ text: String) -> String {
        Template(text).build(inputs)
    }
}

