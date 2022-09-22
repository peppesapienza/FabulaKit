import Foundation
import Combine

open class FabulaBot: AnyFabulaBot, ObservableObject {
        
    public enum State {
        case idle
        case suspended(AnyFabula)
        case finished
    }
    
    public init() {}
    
    @Published
    public var events: [AnyFabula] = []
    
    @Published
    public private(set) var userProps: UserProps = .init()
    
    private(set) lazy var published: AnyPublisher<AnyFabula, Never> = subject.eraseToAnyPublisher()
    
    private let subject: PassthroughSubject<AnyFabula, Never> = .init()
    
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
        guard case let .suspended(fabula) = state, let ask = fabula.value as? Ask else {
            return
        }
        
        userProps.add(input: ask.key, value: text)
        state = .idle
        await resume()
    }
    
    open func start(_ conversation: Conversation) async throws {
        state = .idle
        iterator = conversation.makeIterator()
        await resume()
    }
    
    public final func run<F>(_ fabula: F) async throws where F: Fabula {
        if let first = events.last, first.value is Sleep {
            print("remove sleep")
            events.removeLast()
            try await Task.sleep(seconds: 0.5)
        }
        
        let anyFabula = AnyFabula(fabula)
        
        print("run:", anyFabula.value)
        events.append(anyFabula)
        
        subject.send(anyFabula)
        
        if let sleep = anyFabula.value as? Sleep {
            try await Task.sleep(seconds: sleep.seconds)
        }

        if anyFabula.value is Suspendable {
            state = .suspended(anyFabula)
        }
    }
    
}

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}
