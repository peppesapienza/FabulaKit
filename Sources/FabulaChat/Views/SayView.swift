import SwiftUI

struct SayView: View {
    
    init(_ text: String) {
        self.text = text
    }
    
    private let text: String
    
    var body: some View {
        BoxView {
            Text(text)
        }
    }
    
}

struct SayView_Previews: PreviewProvider {
    static var previews: some View {
        SayView("Test 1")
    }
}
