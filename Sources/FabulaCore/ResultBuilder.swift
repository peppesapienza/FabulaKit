@resultBuilder
public struct FabulaBuilder {
    
    public static func buildBlock<Content: Fabula>(_ content: Content) -> Content {
        content
    }
    
    public static func buildIf<T: Fabula>(_ content: T) -> T {
        content
    }
    
}

public extension FabulaBuilder {
    static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> some Fabula where C0: Fabula, C1: Fabula {
        TupleFabula(c0, c1)
    }
    
    static func buildBlock<C0, C1, C2>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2
    ) -> some Fabula where C0: Fabula, C1: Fabula, C2: Fabula {
        TupleFabula(c0, c1, c2)
    }
    
    static func buildBlock<C0, C1, C2, C3>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3
    ) -> some Fabula where C0: Fabula, C1: Fabula, C2: Fabula, C3: Fabula {
        TupleFabula(c0, c1, c2, c3)
    }
    
    static func buildBlock<C0, C1, C2, C3, C4>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4
    ) -> some Fabula where C0: Fabula, C1: Fabula, C2: Fabula, C3: Fabula, C4: Fabula {
        TupleFabula(c0, c1, c2, c3, c4)
    }
    
    static func buildBlock<C0, C1, C2, C3, C4, C5>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4,
        _ c5: C5
    ) -> some Fabula where C0: Fabula, C1: Fabula, C2: Fabula, C3: Fabula, C4: Fabula, C5: Fabula {
        TupleFabula(c0, c1, c2, c3, c4, c5)
    }
    
    static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4,
        _ c5: C5,
        _ c6: C6
    ) -> some Fabula where C0: Fabula, C1: Fabula, C2: Fabula, C3: Fabula, C4: Fabula, C5: Fabula, C6: Fabula {
        TupleFabula(c0, c1, c2, c3, c4, c5, c6)
    }
}
