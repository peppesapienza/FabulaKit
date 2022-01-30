import XCTest
@testable import FabulaCore

extension BotError {
    static let failed: BotError = .init(key: "test_failed", message: "FAIL")
}

extension FabulaEvent {
    func to<E>(_ type: E.Type) throws -> E where E: FabulaEvent {
        try XCTUnwrap(self as? E)
    }
}

final class FabulaKitTests: XCTestCase {
    
    class TestBot: FabulaBot {
        var userInfo: [AnyHashable : Any] = [:]
        var userInput: [String : Any] = [:]
        
        var outputQueue: [FabulaEvent] = []
        
        func enqueue(sequence: [AnyFabula]) throws {
            var context = BotContext(bot: self, input: "")
            for x in sequence {
                try x.run(in: &context)
            }
        }

        func reply(_ text: String) {
            isWaitingInput = false
        }
        
        func say(_ event: Say.Event) {
            outputQueue.append(event)
        }
        
        func ask(_ event: Ask.Event) {
            isWaitingInput = true
            outputQueue.append(event)
        }
    }
    
    func test_conversation() throws {
        
        let bot = TestBot()
        
        let conv = Conversation(key: "conv") {
            Say("say_1")
            Say("say_2")
            Ask("ask_1", key: "ask_1")
        }
        
        try bot.run(conv)
        XCTAssertEqual(bot.outputQueue.count, 3)
    }
    
    func test_botCanSayAndAsk() throws {
        let bot = TestBot()
        
        let say1 = Say("Hello, welcome to the test example!")
        let ask1 = Ask("Would you like to proceed?", key: "first_ask")
        let say2 = Say("You said: ${first_ask}")
        
        try bot.run(say1)
        try bot.run(ask1)
        
        XCTAssertEqual(
            try bot.outputQueue[0].to(Say.Event.self).text,
            say1.text
        )
        
        XCTAssertEqual(
            try bot.outputQueue[1].to(Ask.Event.self).key,
            ask1.key
        )
        
        let _ = try XCTUnwrap(bot.userInput[ask1.key] as? String)
        XCTAssertTrue(bot.isWaitingInput)
        
        XCTAssertThrowsError(try bot.run(say2)) { error in
            XCTAssertEqual((error as? BotError) ?? .failed, BotError.waitingUserInput)
        }
        
        bot.reply("")
        
    }
    
}
