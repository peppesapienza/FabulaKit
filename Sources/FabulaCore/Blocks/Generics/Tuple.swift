import Foundation

public struct TupleFabula<T>: Fabula, Container {
    public typealias Body = Never
    public typealias Event = Never
    
    public let id: UUID = UUID()
    public let value: T
    public var children: [AnyFabula]
}

extension TupleFabula: Composable {
    public func accept(_ composer: Composer, parent: Node?) -> Node? {
        composer.compose(self, parent: parent)
    }
}


extension TupleFabula {
        
    public init<C0: Fabula, C1: Fabula>(_ c0: C0, _ c1: C1) where T == (C0, C1) {
        self.value = (c0, c1)
        self.children = [AnyFabula(c0), AnyFabula(c1)]
    }
    
}
