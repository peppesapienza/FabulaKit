import FabulaCore
import SwiftUI
import Combine

open class ChatBot: FabulaBot, ObservableObject {
    
    typealias Publisher = AnyPublisher<FabulaEvent, Never>
    
    enum State {
        case idle
        case suspended(FabulaEvent)
    }
    
    init() {}
    
    @Published
    var events: [FabulaEvent] = []
    
    let nextPub: PassthroughSubject<FabulaEvent, Never> = .init()
    
    public var userInfo: [AnyHashable : Any] = [:]
    public var userInput: [String : Any] = [:]
    
    private var cancellables: [AnyCancellable] = []
    
    @Published
    private(set) var state: State = .idle
    
    @Published
    var isOpen: Bool = false
    
    /// The scheduled events queue.
    ///
    /// It's a FIFO queue where the first event appended is the first to be resumed
    private var queue: [Publisher] = []
        
    private var iterator: FabulaIterator?
    
    // TODO: This logic should probably be moved into the Core
    public func enqueue(_ iterator: FabulaIterator) throws {
        self.iterator = iterator
        
        guard case .idle = state, isOpen else {
            return
        }
        
        guard let next = self.iterator?.next() else {
            return
        }
        
        if next.contentType == Conversation.self {
            try enqueue(self.iterator!)
            return
        }
        
        var context = BotContext(bot: self, input: "")
        try next.content.run(in: &context)
        
    }
    
    public func resume() {
        guard iterator != nil else { return }
        try? enqueue(iterator!)
    }
    
    public func reply(_ text: String) {
        
    }
    
    public func say(_ event: Say.Event) {
        schedule(event)
    }
    
    public func ask(_ event: Ask.Event) {
        schedule(event)
    }
    
    // TODO: A method `event.asView(in context:)` implemented into the current module it might replace this imperative logic
    @ViewBuilder
    func map(_ event: FabulaEvent) -> some View {
        switch event {
        case let event as Say.Event:
            SayView(event.text)
            
        case let event as Ask.Event:
            AskView(event, delegate: self)
            
        case _ as TypingEvent:
            TypingView()
            
        default:
            EmptyView()
        }
    }
    
    /// The current active `FabulaEvent` publisher
    private var currentSub: AnyCancellable?
    
    func schedule(_ event: FabulaEvent) {
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

extension ChatBot: AskViewDelegate {
    func askView(didSubmit input: String, from event: Ask.Event) {
        userInput[event.key] = input
        state = .idle
        resume()
    }
}
