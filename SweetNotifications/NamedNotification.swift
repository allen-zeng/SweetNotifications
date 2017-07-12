public protocol NamedNotification {
    static var notificationName: Notification.Name { get }
}

public extension NamedNotification {
    public static var notificationName: Notification.Name {
        return Notification.Name("\(Self.self)")
    }
}
