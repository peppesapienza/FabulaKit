import XCTest
@testable import FabulaChat
import FabulaCore
import Combine

final class ChatTests: XCTestCase {
    
    var cancellables: [AnyCancellable] = []
    
    func test_workerEmits() throws {
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
        
        let chat = ChatBot()
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
            if case let .suspended(event) = state, let ask = event as? Ask.Event {
                XCTAssertEqual(
                    ["hello", "my name is FabulaBot", "what's your name?"],
                    received
                )
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    chat.askView(didSubmit: "giuseppe", from: ask)
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
