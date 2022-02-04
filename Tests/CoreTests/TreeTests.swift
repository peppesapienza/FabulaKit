import XCTest
@testable import FabulaCore

extension Node {
    func to<F>(_ type: F.Type) throws -> F where F: Fabula {
        try XCTUnwrap(content.value as? F)
    }
}

final class TreeTests: XCTestCase {

    
    func test_coversationIsComposedAsExpected() throws {
        
        // TODO: find out a better way to test the tree without casting the node
        /// - conformancy to `CustomDebugStringConvertible`?
        /// - A internal protocol that exposes a text?

        let conversation = Conversation(key: "conversation_1") {
            Say("Welcome!")
            Say("This is an test example!")
            Ask("Would you like to know more?", key: "first_ask")
            Say("you said: ${first_ask}")
        }
        
        let node: Node = .init(conversation, parent: nil)
        TreeComposer().compose(conversation, parent: node)
                
        XCTAssertTrue(node.isRoot)
        XCTAssertFalse(node.isLeaf)
        
        XCTAssertEqual(
            try node.children[0].to(Conversation.self).key,
            conversation.key
        )
        
        let conversationChildren = node.children[0].children
        XCTAssertEqual(conversationChildren.count, 4)
        
        XCTAssertEqual(
            try conversationChildren[0].to(Say.self).text,
            "Welcome!"
        )
        
        XCTAssertEqual(
            try conversationChildren[1].to(Say.self).text,
            "This is an test example!"
        )
        
        XCTAssertEqual(
            try conversationChildren[2].to(Ask.self).text,
            "Would you like to know more?"
        )
        
        XCTAssertEqual(
            try conversationChildren[3].to(Say.self).text,
            "you said: ${first_ask}"
        )
        
    }

    
}
