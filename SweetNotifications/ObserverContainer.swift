public class ObserverContainer {
    private(set) var observers: [NSObjectProtocol]

    public init(observers: [NSObjectProtocol] = []) {
        self.observers = observers
    }

    deinit {
        for observer in observers {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    public func add(_ observer: NSObjectProtocol) {
        observers.append(observer)
    }
}
