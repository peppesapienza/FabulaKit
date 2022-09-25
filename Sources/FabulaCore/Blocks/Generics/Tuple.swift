import Foundation

public struct TupleFabula<T>: Fabula, Container {
    public typealias Body = Never
    
    public let id: UUID = UUID()
    public var children: [any Fabula]
}

extension TupleFabula: Composable {
    public func accept(_ composer: Composer, parent: Node?) -> Node? {
        composer.compose(self, parent: parent)
    }
}


extension TupleFabula {
    public init(_ c0: some Fabula, _ c1: some Fabula) {
        self.children = [c0, c1]
    }
}
