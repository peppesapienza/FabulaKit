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
    
    static func buildPartialBlock<Content>(first content: Content) -> Content where Content: Fabula {
            content
        }

        static func buildPartialBlock<C0, C1>(accumulated: C0, next: C1) -> TupleFabula<(C0, C1)> where C0: Fabula, C1: Fabula {
            TupleFabula(accumulated, next)
        }
    
}
