@resultBuilder
public struct FabulaBuilder {
    
    public static func buildBlock(_ content: some Fabula) -> some Fabula {
        content
    }
    
    public static func buildIf(_ content: some Fabula) -> some Fabula {
        content
    }
    
}

extension FabulaBuilder {
    public static func buildPartialBlock<Content>(first content: Content) -> Content where Content: Fabula {
            content
        }

    public static func buildPartialBlock(
        accumulated: some Fabula,
        next: some Fabula
    ) -> some Fabula {
        TupleFabula<any Fabula>(accumulated, next)
    }
    
}
