import FabulaCore
import SwiftUI
import Combine

open class ChatBot: FabulaBot {
    
    @Published
    var isOpen: Bool = false
    
    // TODO: A method `event.asView(in context:)` implemented into the current module it might replace this imperative logic
    @ViewBuilder
    func map(_ event: FabulaEvent) -> some View {
        switch event {
        case let event as Say.Event:
            SayView(event.text)
            
        case let event as Ask.Event:
            AskView(event, delegate: self)
            
        case _ as TypingEvent:
            TypingView()
            
        default:
            EmptyView()
        }
    }
    
    override open func start(_ conversation: Conversation) throws {
        isOpen = true
        try super.start(conversation)
    }
  
}

extension ChatBot: AskViewDelegate {
    func askView(didSubmit input: String, from event: Ask.Event) {
        reply(input)
    }
}
