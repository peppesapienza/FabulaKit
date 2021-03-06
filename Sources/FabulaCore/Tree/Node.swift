public class Node {
    
    init<F>(_ content: F, parent: Node? = nil) where F: Fabula {
        self.content = content as? AnyFabula ?? AnyFabula(content)
        self.parent = parent
        self.attributes = parent?.attributes ?? []
    }
    
    var isRoot: Bool { parent == nil }
    var isLeaf: Bool { children.isEmpty }
    
    private(set) weak var parent: Node?
    private(set) var children: [Node] = []
    private (set) var attributes: [AnyAttribute] = []

    let content: AnyFabula
    
    var contentType: Any.Type {
        content.fabulaType
    }
    
    func add(child: Node) {
        children.append(child)
    }
    
    func add(attributes: [AnyAttribute]) {
        attributes.forEach { new in
            guard let index = self.attributes.firstIndex(where: { $0.name == new.name && new.shouldReplaceExisting }) else {
                self.attributes.append(new)
                return
            }
            
            self.attributes[index] = new
        }
    }
    
}
