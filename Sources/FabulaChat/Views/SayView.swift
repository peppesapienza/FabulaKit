import SwiftUI
import FabulaCore

struct SayView: View {
    
    @EnvironmentObject<UserProps>
    private var userProps
        
    init(_ say: Say) {
        self.text = say.text
    }
    
    private let text: String
    
    var body: some View {
        BoxView {
            Text(userProps.enrich(text))
        }
    }
    
}

struct SayView_Previews: PreviewProvider {
    static var previews: some View {
        SayView(Say("something"))
            .environmentObject(UserProps())
    }
}
