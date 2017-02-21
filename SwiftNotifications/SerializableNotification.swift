public protocol DeserializableNotification: NamedNotification {
    init(userInfo: [AnyHashable: Any]) throws
}

public protocol SerializableNotification: NamedNotification {
    func toUserInfo() -> [AnyHashable: Any]?
}

public protocol NamedNotification {
    static var notificationName: Notification.Name { get }
}

public extension NamedNotification {
    public static var notificationName: Notification.Name {
        return Notification.Name("\(Self.self)")
    }
}

public enum NotificationSerializationError: Error {
    case noUserInfo, missingRequiredInfo
}
