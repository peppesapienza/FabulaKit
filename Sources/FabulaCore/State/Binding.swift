@propertyWrapper
public struct FabulaBinding<Value> {
    public var wrappedValue: Value {
        get { return getValue() }
        nonmutating set { setValue(newValue) }
    }

    private let getValue: () -> Value
    private let setValue: (Value) -> Void

    public init(get: @escaping () -> Value, set: @escaping (Value) -> Void) {
        self.getValue = get
        self.setValue = set
    }

    public var projectedValue: Self { self }
}
