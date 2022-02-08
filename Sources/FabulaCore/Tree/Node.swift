public class Node {
    
    init<F>(_ content: F, parent: Node? = nil) where F: Fabula {
        self.content = AnyFabula(content)
        self.parent = parent
    }
    
    public let parent: Node?
    private(set) public var children: [Node] = []
    
    public var isRoot: Bool { parent == nil }
    public var isLeaf: Bool { children.isEmpty }
    
    let content: AnyFabula
    
    public var contentType: Any.Type {
        content.fabulaType
    }
    
    func add(child: Node) {
        children.append(child)
    }
}
