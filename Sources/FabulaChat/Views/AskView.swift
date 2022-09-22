import SwiftUI
import FabulaCore

protocol AskViewDelegate: AnyObject {
    func askView(didSubmit input: String, from fabula: Ask) async
}

struct AskView: View {
    
    @Environment(\.theme) var theme
    
    init(_ fabula: Ask, delegate: AskViewDelegate? = nil) {
        self.fabula = fabula
        self.delegate = delegate
    }
    
    @State
    private var input: String = ""
    
    @State
    private var didSend: Bool = false
    
    private let fabula: Ask
    private let delegate: AskViewDelegate?
    
    private var inputColor: Color {
        theme.colors.tint.opacity(0.4)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            BoxView(alignment: .leading) {
                Text(fabula.text)
            }
            
            BoxView(alignment: .leading) {
                inputField()
            }
            .frame(maxWidth: 260)
            .task {
//                #if DEBUG
//                input = "Melbourne"
//                await delegate?.askView(didSubmit: input, from: fabula)
//                didSend.toggle()
//                #endif
            }
        }
    }
    
    
    @ViewBuilder
    private func inputField() -> some View {
        HStack(spacing: 0) {
            TextField("", text: $input)
                .textFieldStyle(.plain)
                .disabled(didSend)
                .padding(7)
            
            Button {
                Task {
                    await delegate?.askView(didSubmit: input, from: fabula)
                    didSend.toggle()
                }
            } label: {
                Image(systemName: didSend ? "checkmark" : "chevron.right")
                    .tint(theme.colors.tint)
                    .font(.headline)
                    .padding([.top, .bottom], 10)
                    .padding([.leading, .trailing], 12)
                    .clipped()
            }
            .disabled(didSend)
            .background(inputColor)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(inputColor, lineWidth: 1)
        )
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        AskView(Ask("What's your name?", key: "some"))
            .previewLayout(.fixed(width: 350, height: 200))
    }
}
