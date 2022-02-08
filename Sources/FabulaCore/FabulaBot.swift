import Foundation
import Combine

open class FabulaBot: AnyFabulaBot, ObservableObject {
    
    public typealias Publisher = AnyPublisher<FabulaEvent, Never>
    
    public enum State {
        case idle
        case suspended(FabulaEvent)
    }
    
    public init() {}
    
    @Published
    public var events: [FabulaEvent] = []
    
    let nextPub: PassthroughSubject<FabulaEvent, Never> = .init()
    
    public var userInfo: [AnyHashable : Any] = [:]
    public var userInput: [String : Any] = [:]
    
    private var cancellables: [AnyCancellable] = []
    
    @Published
    private(set) var state: State = .idle
        
    private var iterator: FabulaIterator?
    private var currentNode: Node?
    
    private lazy var currentContext: BotContext = BotContext(bot: self, input: "")
    
    final public func resume() {
        guard let iterator = iterator else {
            return
        }
        
        guard case .idle = state else {
            //TODO: You can't resume a bot that is not active or idle
            return
        }
        
        guard let next = iterator.next() else {
            // TODO: The tree has been traversed
            return
        }
        
        currentNode = next
        
        do {
            try next.content.run(in: &currentContext)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func reply(_ text: String) {
        guard case let .suspended(event) = state, let ask = event as? Ask.Event else {
            return
        }
        
        userInput[ask.key] = text
        state = .idle
        resume()
    }
    
    public func say(_ event: Say.Event) {
        schedule(event)
    }
    
    public func ask(_ event: Ask.Event) {
        schedule(event)
    }
    
    open func start(_ conversation: Conversation) throws {
        iterator = conversation.makeIterator()
        resume()
    }
    
    /// The current active `FabulaEvent` publisher
    private var currentSub: AnyCancellable?
    
    /// The scheduled events queue.
    ///
    /// It's a FIFO queue where the first event appended is the first to be resumed
    private var queue: [Publisher] = []
    
    final func schedule(_ event: FabulaEvent) {
        print("schedule:", event.type)
        queue.append(map(event))
        
        guard currentSub == nil else {
            //TODO: The scheduler is still working
            return
        }
        
        guard !queue.isEmpty else {
            //TODO: The scheduler doesn't have any more event to publish
            return
        }
        
        currentSub = queue.removeFirst().sink(receiveCompletion: { [self] completion in
            currentSub = nil
            resume()
        }, receiveValue: { [self] event in
            print("dispatch:", event)
            
            // TODO: Add a event.beforeDispatch
            if let first = events.last, first is TypingEvent {
                events.removeLast()
            }
            
            events.append(event)
            nextPub.send(event)
            
            // TODO: Add a event.afterDispatch
            if event is Ask.Event {
                state = .suspended(event)
            }
        })
    }
    
    private func map(_ event: FabulaEvent) -> Publisher {
        Publishers.Merge(
            Just<FabulaEvent>(TypingEvent())
                .delay(for: .seconds(0.7), scheduler: DispatchQueue.main),
            Just<FabulaEvent>(event)
                .delay(for: .seconds(2), scheduler: DispatchQueue.main)
        )
        .eraseToAnyPublisher()
    }
    
}
