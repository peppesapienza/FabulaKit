import Foundation

struct TupleFabula<T>: Fabula, Container {
    typealias Body = Never
    
    let children: [any Fabula]
}

extension TupleFabula: Composable {
    func accept(_ composer: Composer, parent: Node?) -> Node? {
        composer.compose(self, parent: parent)
    }
}


extension TupleFabula {
    init(_ c0: some Fabula, _ c1: some Fabula) {
        self.children = [c0, c1]
    }
}
