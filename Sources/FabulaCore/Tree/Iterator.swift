public struct FabulaIterator: IteratorProtocol {

    init(_ root: Node) {
        self.stack = [.init(index: 0, node: root)]
    }
    
    /// Frontier of all the nodes in the tree that are candidates for returning next
    private(set) var stack: [Step]
    
    public var hasNext: Bool {
        !stack.isEmpty
    }
        
    public mutating func next() -> Node? {
        guard hasNext else { return nil }
        
        while let step = stack.last, step.isEmpty || step.index >= step.count {
            stack.removeLast()
        }
        
        guard let step = stack.popLast() else {
            return nil
        }
        
        /// updates the current mark
        stack.append(.init(index: step.index + 1, node: step.node))
        
        let next: Step = .init(index: 0, node: step.childAtIndex)
        stack.append(next)

        return next.node
    }

    /// Removes the current node from the stack and returns it
    @discardableResult
    mutating func skip() -> Node? {
        stack.popLast()?.node
    }
    
}

extension FabulaIterator {
    struct Step {
        init(index: Int, node: Node) {
            self.index = index
            self.node = node
        }
        
        let index: Int
        let node: Node
        
        var isEmpty: Bool {
            node.isLeaf
        }
        
        var count: Int {
            node.children.count
        }
        
        var childAtIndex: Node {
            node.children[index]
        }
    }
}
