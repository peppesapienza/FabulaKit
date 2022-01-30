public struct TupleFabula<T>: Fabula, Container {
    
    public typealias Body = Never
    public typealias Event = Never
    
    public let value: T
    public let children: [AnyFabula]
}

extension TupleFabula: Composable {
    public func accept(_ composer: Composer, parent: Node) {
        composer.compose(self, parent: parent)
    }
}


extension TupleFabula {
        
    public init<C0: Fabula, C1: Fabula>(_ c0: C0, _ c1: C1) where T == (C0, C1) {
        self.value = (c0, c1)
        self.children = [AnyFabula(c0), AnyFabula(c1)]
    }
    
    public init<C0: Fabula, C1: Fabula, C2: Fabula>(_ c0: C0, _ c1: C1, _ c2: C2) where T == (C0, C1, C2) {
        self.value = (c0, c1, c2)
        self.children = [AnyFabula(c0), AnyFabula(c1), AnyFabula(c2)]
    }
    
    public init<C0: Fabula, C1: Fabula, C2: Fabula, C3: Fabula>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3
    ) where T == (C0, C1, C2, C3) {
        self.value = (c0, c1, c2, c3)
        self.children = [AnyFabula(c0), AnyFabula(c1), AnyFabula(c2), AnyFabula(c3)]
    }
    
    public init<C0: Fabula, C1: Fabula, C2: Fabula, C3: Fabula, C4: Fabula>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4
    ) where T == (C0, C1, C2, C3, C4) {
        self.value = (c0, c1, c2, c3, c4)
        self.children = [AnyFabula(c0), AnyFabula(c1), AnyFabula(c2), AnyFabula(c3), AnyFabula(c4)]
    }
    
    public init<C0: Fabula, C1: Fabula, C2: Fabula, C3: Fabula, C4: Fabula, C5: Fabula>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4,
        _ c5: C5
    ) where T == (C0, C1, C2, C3, C4, C5) {
        self.value = (c0, c1, c2, c3, c4, c5)
        self.children = [AnyFabula(c0), AnyFabula(c1), AnyFabula(c2), AnyFabula(c3), AnyFabula(c4), AnyFabula(c5)]
    }
    
    public init<C0: Fabula, C1: Fabula, C2: Fabula, C3: Fabula, C4: Fabula, C5: Fabula, C6: Fabula>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4,
        _ c5: C5,
        _ c6: C6
    ) where T == (C0, C1, C2, C3, C4, C5, C6) {
        self.value = (c0, c1, c2, c3, c4, c5, c6)
        self.children = [AnyFabula(c0), AnyFabula(c1), AnyFabula(c2), AnyFabula(c3), AnyFabula(c4), AnyFabula(c5), AnyFabula(c6)]
    }
    
}
