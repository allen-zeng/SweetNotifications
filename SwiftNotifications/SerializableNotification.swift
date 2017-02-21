public protocol SerializableNotification: NamedNotification {
    func toUserInfo() -> [AnyHashable: Any]?
}
