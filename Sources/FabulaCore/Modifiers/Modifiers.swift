import Foundation

extension Fabula {
    public func sleep(_ seconds: TimeInterval) -> ModifiedFabula {
        attribute(name: "sleep", value: .number(seconds))
    }
}
