import FabulaCore
import SwiftUI
import Combine

open class ChatBot: FabulaBot {
    
    @Published
    var isOpen: Bool = false
    
    @ViewBuilder
    func map(_ fabula: AnyFabula) -> some View {
        switch fabula.value {
        case let fabula as Say:
            SayView(fabula)
            
        case let fabula as Ask:
            AskView(fabula, delegate: self)
            
        case _ as Sleep:
            TypingView()
            
        default:
            EmptyView()
        }
    }
    
    override open func start(_ conversation: Conversation) async throws {
        events = []
        isOpen = true
        try await super.start(conversation)
    }
  
}

extension ChatBot: AskViewDelegate {
    func askView(didSubmit input: String, from fabula: Ask) async {
        await reply(input)
    }
}
