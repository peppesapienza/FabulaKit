import XCTest
import Combine
@testable import FabulaCore

extension BotError {
    static let failed: BotError = .init(key: "test_failed", message: "FAIL")
}

extension Publisher where Output == any Fabula {
    /// Try casting the Output event to the provided type and republish it if the casting succeeds
    func compactMap<T>(_ type: T.Type) -> Publishers.CompactMap<Self, T> where T: Fabula {
        compactMap { event in
            event as? T
        }
    }
}


final class FabulaKitTests: XCTestCase {
    
    var cancellables: [AnyCancellable] = []
    
    func test_chatResumes_whenInputIsSubmitted() async throws {
        let expStateToSuspend = expectation(description: "The bot should stop running after running an Ask.Event")
        let expChatToResume = expectation(description: "The bot should resume when the input has been provided")

        /// the received messages displayed
        var received: [String] = []
        
        let conversation = Conversation(key: "some", {
            Say("hello")
            Say("my name is FabulaBot")
            Ask("what's your name?", key: "username")
                .onSubmit { text in
                    print("onSubmit:", text)
                }
            Say("my name is: ${username}")
        })
        
        let chat = FabulaBot()
        
        chat.published.compactMap(Say.self).sink { event in
            received.append(Template(event.text).build(chat.userProps.inputs))
        }.store(in: &cancellables)
        
        chat.published.compactMap(Ask.self).sink { event in
            received.append(Template(event.text).build(chat.userProps.inputs))
        }.store(in: &cancellables)
                
        /// check that the state mutate to `.suspended` and then assert
        chat.$state.sink { state in
            if case let .suspended(event) = state, let _ = event as? Ask {
                XCTAssertEqual(
                    ["hello", "my name is FabulaBot", "what's your name?"],
                    received
                )
                
                Task(priority: .userInitiated) {
                    await chat.reply("giuseppe")
                }
                
                expStateToSuspend.fulfill()
            }
            
            if case .finished = state {
                XCTAssertEqual(received[3], "my name is: giuseppe")
                expChatToResume.fulfill()
            }
            
        }.store(in: &cancellables)
        
        try await chat.start(conversation)

        wait(for: [expStateToSuspend, expChatToResume], timeout: 10)
    }
    
   
    func test_askMutates_whenInputSent() async throws {
        let ask = Ask("ask", key: "ask")
        
        try await ask.submit("A")
        XCTAssertEqual(ask.input, "A")
        XCTAssertEqual(ask.$input.wrappedValue, "A")
        ask.$input.wrappedValue = "B"
        XCTAssertEqual(ask.input, "B")
    }
}
