public protocol Composer {
    func compose(_ say: Say, parent: Node)
    func compose(_ ask: Ask, parent: Node)
    func compose(_ conversation: Conversation, parent: Node)
    
    func compose(_ any: AnyFabula, parent: Node)
    func compose<T>(_ tuple: TupleFabula<T>, parent: Node)
}

public protocol Composable {
    func accept(_ composer: Composer, parent: Node)
}

public class TreeComposer: Composer {
    
    private var conversations: Set<String> = .init()
    
    public func compose(_ conversation: Conversation, parent: Node) {
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
        
        parent.add(child: node)
    }
    
    public func compose(_ say: Say, parent: Node) {
        let node = Node(say, parent: parent)
        parent.add(child: node)
    }
    
    public func compose(_ ask: Ask, parent: Node) {
        /// For the time being we allow registering ask with same key
        let node = Node(ask, parent: parent)
        parent.add(child: node)
    }
    
    public func compose(_ anyFabula: AnyFabula, parent: Node) {
        guard let composable = (anyFabula.value as? Composable) else {
            fatalError("""
            Your \(anyFabula.fabulaType) must implements \(Composable.self) to be used inside a \(FabulaBuilder.self).
            """)
        }
        
        composable.accept(self, parent: parent)
    }
    
    /// TupleFabula is treated as flat container
    public func compose<T>(_ tuple: TupleFabula<T>, parent: Node) {
        for fabula in tuple.children {
            fabula.accept(self, parent: parent)
        }
    }
    
}
