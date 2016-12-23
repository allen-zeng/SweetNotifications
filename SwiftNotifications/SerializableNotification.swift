public protocol SerializableNotification {
    init(userInfo: [AnyHashable: Any]) throws

    static var notificationName: Notification.Name { get }

    func toUserInfo() -> [AnyHashable: Any]?
}

public extension SerializableNotification {
    public static var notificationName: Notification.Name {
        return Notification.Name("\(Self.self)")
    }
}

public enum NotificationSerializationError: Error {
    case noUserInfo, missingRequiredInfo
}
