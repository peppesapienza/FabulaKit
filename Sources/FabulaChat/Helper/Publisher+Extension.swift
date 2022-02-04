import Combine
import FabulaCore

extension Publisher where Output == FabulaEvent {
    /// Try casting the Output event to the provided type and republish it if the casting succeeds
    func compactMap<T>(_ type: T.Type) -> Publishers.CompactMap<Self, T> where T: FabulaEvent {
        compactMap { event in
            event as? T
        }
    }
}
