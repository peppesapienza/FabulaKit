import XCTest
@testable import FabulaCore

extension Node {
    func to<F>(_ type: F.Type) throws -> F where F: Fabula {
        try XCTUnwrap(content as? F)
    }
}

final class TreeTests: XCTestCase {

    func test_coversationIsComposedAsExpected() throws {
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
    
}
