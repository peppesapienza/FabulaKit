import SwiftUI

struct DotView: View {
    
    @Environment(\.theme) private var theme

    let size: CGFloat = 10

    var body: some View {
        Circle()
            .foregroundColor(theme.colors.tint)
            .frame(width: size, height: size)
    }
    
}


extension Animation {
    static func pulse(_ delay: Int) -> Animation {
        Animation.easeInOut
            .speed(0.4)
            .repeatForever(autoreverses: false)
            .delay(0.1 * Double(delay))
    }
}

extension AnyTransition {
    static var scaleAndFade: AnyTransition {
        let insertion = AnyTransition.scale(scale: 0)
            .combined(with: .opacity)
        let removal = AnyTransition.scale
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}

struct TypingView: View {
    
    init(isHidden: Binding<Bool> = .constant(false)) {
        self._isHidden = isHidden
    }

    @Binding private var isHidden: Bool
    
    @State var isAnimating: Bool = false
    
    var body: some View {
        if !isHidden {
            BoxView {
                HStack {
                    DotView()
                        .opacity(isAnimating ? 0 : 1)
                        .animation(.pulse(0), value: isAnimating ? 0 : 1)
                    DotView()
                        .opacity(isAnimating ? 0 : 1)
                        .animation(.pulse(1), value: isAnimating ? 0 : 1)
                    DotView()
                        .opacity(isAnimating ? 0 : 1)
                        .animation(.pulse(2), value: isAnimating ? 0 : 1)
                }.onAppear {
                    isAnimating = true
                }.onDisappear {
                    isAnimating = false
                }
            }
        } else {
            EmptyView()
        }
    }

}

struct TypingView_Previews: PreviewProvider {
    static var previews: some View {
        TypingView()
            .previewLayout(.fixed(width: 200, height: 200))
    }
}
