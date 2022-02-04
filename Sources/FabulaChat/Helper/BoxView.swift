import SwiftUI

/// A wrapper view with a `Capsule` shape and some default paddings
public struct BoxView<Content>: View where Content: View {
        
    public init(
        alignment: HorizontalAlignment = .center,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.alignment = alignment
        self.content = content
    }
    
    private let alignment: HorizontalAlignment
    private let content: () -> Content
    
    public var body: some View {
        VStack(alignment: alignment) {
            content()
                .padding([.top, .bottom], 10)
                .padding([.leading, .trailing], 16)
        }
        .background(Color.gray)
        .clipShape(Capsule())
    }
}

struct BoxView_Previews: PreviewProvider {
    static var previews: some View {
        BoxView {
            Text("some text")
        }
    }
}
