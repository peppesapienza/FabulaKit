import SwiftUI
import FabulaCore

public struct ChatView: View {
    
    @Environment(\.theme) private var theme
    
    public init(bot: ChatBot) {
        self.bot = bot
    }
    
    @ObservedObject
    private var bot: ChatBot
    
    public var body: some View {
        ZStack {
            introView()
            if bot.isOpen {
                chatView()
            }
        }.tint(theme.colors.tint)
    }
    
    @ViewBuilder
    private func introView() -> some View {
        VStack(alignment: .leading) {
            Spacer()
            
            HStack {
                ChatBubble()
                    .onTapGesture {
                        bot.isOpen.toggle()
                    }
                Spacer()
            }
        }
        .padding([.top, .leading, .trailing])
    }
    
    @ViewBuilder
    private func chatView() -> some View {
        VStack {
            HStack {
                Text("FabulaKitDemo")
                    .font(.title2)
                    .fontWeight(.black)
                Spacer()
                Button(action: {
                    bot.isOpen.toggle()
                }, label: {
                    Image(systemName: "xmark")
                        .padding([.top, .bottom], 6)
                })
                .buttonStyle(.bordered)
            }
            .padding()
            .background(theme.colors.box)
            
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(bot.events, id: \.id) { fabula in
                        bot.map(fabula)
                            .environmentObject(bot.userProps)
                    }
                }
            }.padding()
        }
        .background(theme.colors.background)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        let conv = Conversation(key: "some") {
            Say(
            """
            Hey there 👋!
            
            This is a scripted Conversation
            """)
            .sleep(2)
            Say("It runs automatically and it stops when the user needs to provide an input")
            .sleep(4)
            Say("Like this...")
            .sleep(2)
            Ask("Where do you live?", key: "city")
            .sleep(4)
            Say("Wow!! I love ${city} 🌏")
            .sleep(2)
        }
        
        let bot = ChatBot()
        
        return ZStack {
            VStack {
                HStack {
                    Spacer()
                    Button("start") {
                        Task {
                            try? await bot.start(conv)
                        }
                    }.buttonStyle(.bordered)
                }
                Spacer()
            }
            .padding()
            
            ChatView(bot: bot)
        }
        .previewInterfaceOrientation(.portrait)
    }
}
