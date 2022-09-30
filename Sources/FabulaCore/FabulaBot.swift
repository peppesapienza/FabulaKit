import Foundation
import Combine

open class FabulaBot: AnyFabulaBot, ObservableObject {
        
    public enum State {
        case idle
        case suspended(any Suspendable)
        case finished
    }
    
    public init() {}
    
    @Published
    public var events: [any Fabula] = []
    
    @Published
    public private(set) var userProps: UserProps = .init()
    
    private(set) lazy var published: AnyPublisher<any Fabula, Never> = subject.eraseToAnyPublisher()
    
    private let subject: PassthroughSubject<any Fabula, Never> = .init()
    
    private var cancellables: [AnyCancellable] = []
    
    @Published
    private(set) var state: State = .idle
        
    private var iterator: FabulaIterator?
    private var currentNode: Node?
    
    private lazy var currentContext: BotContext = BotContext(bot: self)
    
    final public func resume() async {
        guard let iterator = iterator else {
            return
        }
        
        guard case .idle = state else {
            //TODO: You can't resume a bot that is not active or idle
            return
        }
        
        guard let next = iterator.next() else {
            state = .finished
            return
        }
        
        currentNode = next
        
        do {
            try await next.content.run(in: &currentContext)
            await resume()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func reply(_ text: String) async {
        guard case let .suspended(fabula) = state else {
            return
        }
        
        print("reply:", text)
        userProps.add(input: fabula.key, value: text)
        state = .idle
        await resume()
    }
    
    open func start(_ conversation: Conversation) async throws {
        state = .idle
        iterator = conversation.makeIterator()
        await resume()
    }
    
    public final func run(_ fabula: some Fabula) async throws {
        if let first = events.last, first is Sleep {
            print("remove sleep")
            events.removeLast()
            try await Task.sleep(seconds: 0.5)
        }
                
        print("run:", fabula)
        
        events.append(fabula)
        subject.send(fabula)
    }
    
    public final func suspend(at fabula: some Suspendable) async throws {
        if case let .suspended(fabula) = state {
            throw BotError.alreadySuspended(at: fabula)
        }
        
        print("suspended at:", fabula)
        state = .suspended(fabula)
    }
}

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}
