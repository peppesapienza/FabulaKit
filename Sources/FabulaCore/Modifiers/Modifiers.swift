import Foundation

extension Fabula {
    public func sleep(_ seconds: TimeInterval) -> some Fabula {
        attribute(name: "sleep", value: .number(seconds))
    }
}
