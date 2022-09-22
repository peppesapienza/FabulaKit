import Foundation

public struct Sleep: Fabula {
    public typealias Body = Never
    
    public init(_ seconds: TimeInterval) {
        self.seconds = seconds
    }
    
    public let id: UUID = UUID()
    public let seconds: TimeInterval
}

extension Sleep: Composable {
    public func accept(_ composer: Composer, parent: Node?) -> Node? {
        assertionFailure("\(Self.self) is not currently supported")
    }
}
