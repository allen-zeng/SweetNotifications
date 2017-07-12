public protocol DeserializableNotification: NamedNotification {
    init(userInfo: [AnyHashable: Any]) throws
}
