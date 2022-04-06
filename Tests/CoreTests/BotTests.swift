import XCTest
import Combine
@testable import FabulaCore

extension BotError {
    static let failed: BotError = .init(key: "test_failed", message: "FAIL")
}

extension FabulaEvent {
    func to<E>(_ type: E.Type) throws -> E where E: FabulaEvent {
        try XCTUnwrap(self as? E)
    }
}


extension Publisher where Output == FabulaEvent {
    /// Try casting the Output event to the provided type and republish it if the casting succeeds
    func compactMap<T>(_ type: T.Type) -> Publishers.CompactMap<Self, T> where T: FabulaEvent {
        compactMap { event in
            event as? T
        }
    }
}


final class FabulaKitTests: XCTestCase {
    
    class TestBot: AnyFabulaBot {

        var userInfo: [AnyHashable : Any] = [:]
        var userInput: [String : Any] = [:]
        
        var outputQueue: [FabulaEvent] = []
        var isWaitingInput: Bool = false
        
        var currentAsk: Ask.Event?
        
        func start(_ conversation: Conversation) throws {
            var context = BotContext(bot: self, input: "")
            let iterator = conversation.makeIterator()
            while let next = iterator.next() {
                try next.content.run(in: &context)
            }
        }
        
        func reply(_ text: String) {
            isWaitingInput = false
            
            if let currentAsk = currentAsk {
                userInput[currentAsk.key] = text
            }
        }
        
        func say(_ event: Say.Event) {
            outputQueue.append(event)
        }
        
        func ask(_ event: Ask.Event) {
            isWaitingInput = true
            currentAsk = event
            outputQueue.append(event)
        }
        
        func resume() {
            
        }
    }
    
    var cancellables: [AnyCancellable] = []
    
    func test_conversation() throws {
        let conv = Conversation(key: "conv") {
            Say("say_1")
            Say("say_2")
            Ask("ask_1", key: "ask_1")
        }
        
        let bot = TestBot()
        try bot.start(conv)
        
        XCTAssertEqual(bot.outputQueue.count, 3)
    }
    
    func test_botCanSayAndAsk() throws {
        let say1 = Say("Hello, welcome to the test example!")
        let ask1 = Ask("Would you like to proceed?", key: "first_ask")
        let say2 = Say("You said: ${first_ask}")
                
        let bot = TestBot()
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

        bot.reply("yes")        
        try bot.run(say2)
        
        XCTAssertEqual(
            try bot.outputQueue[2].to(Say.Event.self).text,
            "You said: yes"
        )
        
    }
    
    func test_chatResumes_whenInputIsSubmitted() throws {
        let expStateToSuspend = expectation(description: "The bot should stop running after running an Ask.Event")
        let expChatToResume = expectation(description: "The bot should resume when the input has been provided")
        
        /// a publisher used for test purpose
        let testPub: PassthroughSubject<Void, Never> = .init()
        /// the received messages displayed
        var received: [String] = []
        
        let conversation = Conversation(key: "some", {
            Say("hello")
            Say("my name is FabulaBot")
            Ask("what's your name?", key: "username")
            Say("my name is: ${username}")
        })
        
        let chat = FabulaBot()
        
        try chat.start(conversation)
        
        //TODO: It's clear I need to find a better way to store event
        
        /// stores the event as text
        chat.nextPub.compactMap(Say.Event.self).sink { event in
            received.append(event.text)
        }.store(in: &cancellables)
        
        chat.nextPub.compactMap(Ask.Event.self).sink { event in
            received.append(event.text)
        }.store(in: &cancellables)
        
        /// check that the state mutate to `.suspended` and then assert
        chat.$state.sink { state in
            if case let .suspended(event) = state, let _ = event as? Ask.Event {
                XCTAssertEqual(
                    ["hello", "my name is FabulaBot", "what's your name?"],
                    received
                )
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    chat.reply("giuseppe")
                    testPub.send(())
                    expStateToSuspend.fulfill()
                }

            }
        }.store(in: &cancellables)
        
        //TODO: Removing the delay with a fabula modifier should speed up the testing
        
        /// Then wait for the testPub to publish when the input has been provided
        testPub.delay(for: .seconds(3), scheduler: RunLoop.main).sink { _ in
            XCTAssertEqual(received[3], "my name is: giuseppe")
            expChatToResume.fulfill()
        }.store(in: &cancellables)
        
        wait(for: [expStateToSuspend, expChatToResume], timeout: 20)
    }
    
   
}
