public class Node {
    
    internal init<F>(_ content: F, parent: Node? = nil) where F: Fabula {
        self.content = content as? AnyFabula ?? AnyFabula(content)
        self.parent = parent
        self.attributes = parent?.attributes ?? []
    }
    
    public var isRoot: Bool { parent == nil }
    public var isLeaf: Bool { children.isEmpty }
    
    internal private(set) weak var parent: Node?
    internal private(set) var children: [Node] = []
     
    internal let content: AnyFabula
    internal var attributes: [AnyAttribute] = []
    
    internal var contentType: Any.Type {
        content.fabulaType
    }
    
    internal func add(child: Node) {
        children.append(child)
    }
}
