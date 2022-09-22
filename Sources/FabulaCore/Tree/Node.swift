public class Node {
    
    init<F>(_ content: F, parent: Node? = nil) where F: Fabula {
        self.content = content as? AnyFabula ?? AnyFabula(content)
        self.parent = parent
    }
    
    var isRoot: Bool { parent == nil }
    var isLeaf: Bool { children.isEmpty }
    
    private(set) weak var parent: Node?
    private(set) var children: [Node] = []
    
    let content: AnyFabula
    
    var contentType: Any.Type {
        content.fabulaType
    }
    
    func add(child: Node) {
        children.append(child)
    }
}
