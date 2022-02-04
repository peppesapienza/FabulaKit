public final class Node {
    
    init<F>(_ content: F, parent: Node? = nil) where F: Fabula {
        self.content = AnyFabula(content)
        self.parent = parent
    }
    
    public let parent: Node?
    private(set) public var children: [Node] = []
    
    public var isRoot: Bool { parent == nil }
    public var isLeaf: Bool { children.isEmpty }
    
    public let content: AnyFabula
    
    public var contentType: Any.Type {
        content.fabulaType
    }
    
    public func add(child: Node) {
        children.append(child)
    }
    
    /// Returns an iterator over the children of the current node
    public func makeIterator() -> FabulaIterator {
        FabulaIterator(self)
    }
}
