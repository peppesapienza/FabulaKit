import SwiftUI
import FabulaCore

public struct ChatView: View {
    
    public init(bot: ChatBot) {
        self.bot = bot
    }
    
    @ObservedObject
    private var bot: ChatBot
    
    public var body: some View {
        ScrollView {
            if !bot.events.isEmpty {
                LazyVStack(alignment: .trailing) {
                    ForEach(bot.events, id: \.id) { event in
                        bot.map(event)
                            .flip()
                    }
                }
            }
        }
        .padding()
        .flip()
        .background(.clear)
        .onAppear {
            
        }
    }
}

extension View {
    public func flip() -> some View {
        return self
            .rotationEffect(.radians(.pi))
            .scaleEffect(x: -1, y: 1, anchor: .center)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        let conv = Conversation(key: "some") {
            Say("Hello, world!")
            Say("This is a test example")
            Ask("What's your name?", key: "username")
            Say("your name is: ${username}")
        }
        
        let bot = ChatBot()
        
        return ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button("start") {
                        try? bot.start(conv)
                    }.buttonStyle(.bordered)
                    
                    Button("reset") {
                    }.buttonStyle(.bordered)
                }
                Spacer()
            }
            .padding()
            .background(Color.orange)
            
            ChatView(bot: bot)
                .background(.clear)
        }
    }
}
