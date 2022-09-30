import Foundation

public struct Sleep: Fabula, Presentable {
    public typealias Body = Never
    
    public init(_ seconds: TimeInterval) {
        self.seconds = seconds
    }
    
    public let id: String = UUID().uuidString
    public let seconds: TimeInterval
}

extension Sleep: Composable {
    public func accept(_ composer: Composer, parent: Node?) -> Node? {
        assertionFailure("\(Self.self) is not currently supported")
        return nil
    }
}
