# [WIP] FabulaKit

FabulaKit is a DSL for writing scripted conversation with a Bot. It can be used to build FAQ, provide app updates or guide the user into your product.

```swift
let conv = Conversation(key: "some") {
  Say(
  """
  Hey there 👋!
  
  This is is a scripted Conversation
  """)
  Say("It runs automatically and it stops when the user needs to provide an input")
  Say("Like this...")
  Ask("Where do you live?", key: "city")
  Say("Wow!! I love ${city} 🌏")
}

let bot = ChatBot()
bot.start(conv)

/// In some view
var body: some View {
  ZStack {
    YourMainView()
    ChatView(bot: bot)
  }
}

```

![alt text](https://media.giphy.com/media/jn3c5QBVHoxVxPtcS6/giphy.gif)
