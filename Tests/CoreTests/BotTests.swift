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
    
    var cancellables: [AnyCancellable] = []
    
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
