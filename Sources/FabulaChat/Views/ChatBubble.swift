import SwiftUI

struct ChatBubble: View {
    
    @Environment(\.theme) var theme
    
    var body: some View {
        Text("🤖")
            .padding(20)
            .background(
                Circle()
                    .foregroundColor(theme.colors.tint)
            )
    }
}

struct ChatBubble_Previews: PreviewProvider {
    static var previews: some View {
        ChatBubble()
            .previewLayout(.fixed(width: 200, height: 200))
    }
}
