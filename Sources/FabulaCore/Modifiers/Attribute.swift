internal protocol AnyAttribute {
    var name: String { get }
    var value: AnyValue { get }
    var shouldReplaceExisting: Bool { get }
}

public enum AnyValue {
    case bool(Bool)
    case number(Double)
    case string(String)
    
    var number: Double? {
        guard case let .number(x) = self else {
            return nil
        }
        return x
    }
    
    var bool: Bool? {
        guard case let .bool(x) = self else {
            return nil
        }
        return x
    }
    
    var string: String? {
        guard case let .string(x) = self else {
            return nil
        }
        return x
    }
}

public struct Attribute<Context>: AnyAttribute {
    public let name: String
    public let value: AnyValue
    public let shouldReplaceExisting: Bool
    
    internal init(name: String, value: AnyValue, shouldReplaceExisting: Bool = true) {
        self.name = name
        self.value = value
        self.shouldReplaceExisting = shouldReplaceExisting
    }
}
