@propertyWrapper
public struct FabulaState<Value> {
    
    private class Storage {
        var value: Value
        init(value: Value) { self.value = value }
    }
    
    private let storage: Storage
    
    var binding: FabulaBinding<Value> {
        FabulaBinding(get: { wrappedValue }, set: { wrappedValue = $0 })
    }
    
    public var wrappedValue: Value {
        get { storage.value }
        nonmutating set { storage.value = newValue }
    }
    
    public var projectedValue: FabulaBinding<Value> { binding }
    
    public init(wrappedValue value: Value) {
        self.storage = Storage(value: value)
    }
    
}
