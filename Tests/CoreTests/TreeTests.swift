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
        
        let node = try XCTUnwrap(TreeComposer().compose(conversation, parent: nil))
                
        XCTAssertTrue(node.isRoot)
        XCTAssertFalse(node.isLeaf)
        
        XCTAssertEqual(
            try node.children[0].to(Say.self).text,
            "Welcome!"
        )
        
        XCTAssertEqual(
            try node.children[1].to(Say.self).text,
            "This is an test example!"
        )
        
        XCTAssertEqual(
            try node.children[2].to(Ask.self).text,
            "Would you like to know more?"
        )
        
        XCTAssertEqual(
            try node.children[3].to(Say.self).text,
            "you said: ${first_ask}"
        )
        
    }

    
    func test_sleepModifier() throws {
        
        let fabula = Conversation(key: "hello") {
            Say("sleep 2")
                .sleep(2)
                .sleep(4)
            
            Say("sleep 3")
        }.sleep(3)
        
        let node = try XCTUnwrap(TreeComposer().compose(fabula, parent: nil))
        
        XCTAssertEqual(node.attributes[0].name, "sleep")
        XCTAssertEqual(node.attributes[0].value.number, 3)
        
        let say2 = node.children[0]
        XCTAssertEqual(say2.attributes[0].value.number, 4)
        
        let say3 = node.children[1]
        XCTAssertEqual(say3.attributes[0].value.number, 3)
    }
    
    
}
