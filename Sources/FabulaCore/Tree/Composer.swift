public protocol Composer {
    func compose(_ say: Say, parent: Node?) -> Node?
    func compose(_ ask: Ask, parent: Node?) -> Node?
    
    @discardableResult
    func compose(_ conversation: Conversation, parent: Node?) -> Node?
}

public protocol Composable {
    @discardableResult
    func accept(_ composer: Composer, parent: Node?) -> Node?
}

public class TreeComposer: Composer {
    
    private var conversations: Set<String> = .init()
        
    public func compose(_ conversation: Conversation, parent: Node?) -> Node? {
        /// This should be the best way to prevent duplicated keys
        /// Enforce uniqueness will enable an easy way to jump to conversation from another
        precondition(!conversations.contains(conversation.key), """
        You already have a \(Conversation.self) with the same key: \(conversation.key)
        """)
        
        conversations.insert(conversation.key)
        
        let node = Node(conversation, parent: parent)
        
        for fabula in conversation.children {
            fabula.accept(self, parent: node)
        }
        
        parent?.add(child: node)
        
        return node
    }
    
    public func compose(_ say: Say, parent: Node?) -> Node? {
        let node = Node(say, parent: parent)
        parent?.add(child: node)
        return node
    }
    
    public func compose(_ ask: Ask, parent: Node?) -> Node? {
        /// For the time being we allow registering ask with same key
        let node = Node(ask, parent: parent)
        parent?.add(child: node)
        return node
    }

}

extension Composer {
    func compose<Content, Modifier>(_ modified: ModifiedFabula<Content, Modifier>, parent: Node?) -> Node? {
        let node = Node(modified, parent: parent)
        
        if let container = modified.content as? Container {
            for child in container.children {
                let childNode = child.accept(self, parent: node)
                
                if let childNode = childNode {
                    node.add(child: childNode)
                }
            }
        }
        
        parent?.add(child: node)
        return node
    }
    
    func compose<T>(_ tuple: TupleFabula<T>, parent: Node?) -> Node? {
        for fabula in tuple.children {
            fabula.accept(self, parent: parent)
        }
        
        return nil
    }
}
