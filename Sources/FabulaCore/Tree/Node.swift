public class Node {
    
    init(_ content: some Fabula, parent: Node? = nil) {
        self.content = content
        self.parent = parent
    }
    
    var isRoot: Bool { parent == nil }
    var isLeaf: Bool { children.isEmpty }
    
    private(set) weak var parent: Node?
    private(set) var children: [Node] = []
    
    let content: any Fabula
    
    func add(child: Node) {
        children.append(child)
    }
}
