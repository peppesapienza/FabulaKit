import XCTest
@testable import FabulaCore

extension BotError {
    static let failed: BotError = .init(key: "test_failed", message: "FAIL")
}

final class FabulaKitTests: XCTestCase {
    
    class TestBot: FabulaBot {
        var userInfo: [AnyHashable : Any] = [:]
        var userInput: [String : Any] = [:]
        
        var outputQueue: [String] = []
        
        func enqueue(sequence: [AnyFabula]) throws {
            var context = BotContext(bot: self, input: "")
            for x in sequence {
                try x.run(in: &context)
            }
        }

        func reply(_ text: String) {
            isWaitingInput = false
        }
        
        func say(_ text: String) {
            outputQueue.append(text)
        }
        
        func ask(_ text: String) {
            isWaitingInput = true
            outputQueue.append(text)
        }
    }
    
    func test_conversation() throws {
        
        let bot = TestBot()
        
        let conv = Conversation(key: "conv") {
            Say("say_1")
            Say("say_2")
            Ask("ask_1", key: "ask_1")
        }
        
        try bot.run(conversation: conv)
        XCTAssertEqual(bot.outputQueue.count, 3)
    }
    
    func test_botCanSayAndAsk() throws {
        let bot = TestBot()
        
        let say1 = Say("Hello, welcome to the test example!")
        let ask1 = Ask("Would you like to proceed?", key: "first_ask")
        let say2 = Say("You said: ${first_ask}")
        
        try bot.run(say1)
        try bot.run(ask1)
        
        XCTAssertEqual(bot.outputQueue, [
            say1.text,
            ask1.text
        ])
        
        let _ = try XCTUnwrap(bot.userInput[ask1.key] as? String)
        XCTAssertTrue(bot.isWaitingInput)
        
        XCTAssertThrowsError(try bot.run(say2)) { error in
            XCTAssertEqual((error as? BotError) ?? .failed, BotError.waitingUserInput)
        }
        
        bot.reply("")
        
    }
    
}