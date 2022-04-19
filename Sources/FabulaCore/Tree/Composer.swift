public protocol Composer {
    func compose(_ say: Say, parent: Node?) -> Node?
    func compose(_ ask: Ask, parent: Node?) -> Node?
    
    @discardableResult func compose(_ conversation: Conversation, parent: Node?) -> Node?
    
    func compose(_ modified: ModifiedFabula, parent: Node?) -> Node?
    
    func compose(_ any: AnyFabula, parent: Node?) -> Node?
    func compose<T>(_ tuple: TupleFabula<T>, parent: Node?) -> Node?
}

public protocol Composable {
    func accept(_ composer: Composer, parent: Node?) -> Node?
}

public class TreeComposer: Composer {
    
    private var conversations: Set<String> = Set()
    /// The attributes to be passed to the children nodes of a modified fabula content
    private var attributes: [AnyAttribute] = []
        
    public func compose(_ conversation: Conversation, parent: Node?) -> Node? {
        /// This should be the best way to prevent duplicated keys
        /// Enforce uniqueness will enable an easy way to jump to conversation from another
        precondition(!conversations.contains(conversation.key), """
        You already have a \(Conversation.self) with the same key: \(conversation.key)
        """)
        
        conversations.insert(conversation.key)
        
        let node = enrich(Node(parent: parent))
        
        for fabula in conversation.children {
            fabula.accept(self, parent: node)
        }
        
        parent?.add(child: node)
        
        return node
    }
    
    public func compose(_ say: Say, parent: Node?) -> Node? {
        let node = enrich(Node(say, parent: parent))
        parent?.add(child: node)
        return node
    }
    
    public func compose(_ ask: Ask, parent: Node?) -> Node? {
        /// For the time being we allow registering ask with same key
        let node = enrich(Node(ask, parent: parent))
        parent?.add(child: node)
        return node
    }
    
    public func compose(_ modified: ModifiedFabula, parent: Node?) -> Node? {
        attributes = modified.attributes

        guard let node = modified.content.accept(self, parent: parent) else {
            return nil
        }
        
        node.add(attributes: modified.attributes)
        
        attributes = []
        return node
    }
    
    public func compose(_ anyFabula: AnyFabula, parent: Node?) -> Node? {
        guard let composable = (anyFabula.value as? Composable) else {
            fatalError("""
            Your \(anyFabula.fabulaType) must implements \(Composable.self) to be used inside a \(FabulaBuilder.self).
            """)
        }
        
        return composable.accept(self, parent: parent)
    }
    
    /// TupleFabula is treated as flat container
    public func compose<T>(_ tuple: TupleFabula<T>, parent: Node?) -> Node? {
        
        for fabula in tuple.children {
            fabula.accept(self, parent: parent)
        }
        
        return nil
    }
    
    private func enrich(_ node: Node) -> Node {
        node.add(attributes: attributes)
        return node
    }
}
