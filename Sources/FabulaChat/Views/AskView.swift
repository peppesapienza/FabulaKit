import SwiftUI
import FabulaCore

protocol AskViewDelegate: AnyObject {
    func askView(didSubmit input: String, from event: Ask.Event)
}

struct AskView: ChatBlockView {
    
    init(_ event: Ask.Event, delegate: AskViewDelegate? = nil) {
        self.event = event
        self.delegate = delegate
    }
    
    @State
    private var input: String = ""
    private let event: Ask.Event
    private let delegate: AskViewDelegate?
    
    var body: some View {
        VStack(alignment: .trailing) {
            BoxView {
                Text(event.text)
            }
            BoxView {
                TextField("write here...", text: $input)
                    .multilineTextAlignment(.trailing)
                    .textFieldStyle(.plain)
                    .onSubmit {
                        delegate?.askView(didSubmit: input, from: event)
                    }
            }
            .frame(maxWidth: 200)
            .onAppear {
                #if DEBUG
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    input = "TEST"
                    delegate?.askView(didSubmit: input, from: event)
                }
                #endif
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        AskView(.init(text: "What's your name?", key: "some"))
    }
}
