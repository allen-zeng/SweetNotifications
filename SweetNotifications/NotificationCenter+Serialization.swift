public extension NotificationCenter {
    public func watch<T: DeserializableNotification>(
        object: AnyObject? = nil,
        queue: OperationQueue = OperationQueue.main,
        handler: @escaping (T) -> Void) -> NSObjectProtocol
    {
        return addObserver(
            forName: T.notificationName,
            object: object,
            queue: queue,
            using: { notification in
                guard let userInfo = notification.userInfo else {
                    sweetNotificationsGlobalErrorHandler(NotificationSerializationError.noUserInfo, "\(T.self)")
                    return
                }

                do {
                    let serializedNotification = try T(userInfo: userInfo as [NSObject : AnyObject])

                    handler(serializedNotification)
                } catch {
                    sweetNotificationsGlobalErrorHandler(error, "\(T.self)")
                }
            })
    }

    public func post<T: SerializableNotification>(_ notification: T, object: AnyObject? = nil) {
        self.post(name: T.notificationName, object: object, userInfo: notification.toUserInfo())
    }

    public func post(_ name: Notification.Name, object: AnyObject? = nil) {
        self.post(name: name, object: object, userInfo: nil)
    }

    public func watch(
        for name: Notification.Name,
        object: AnyObject? = nil,
        queue: OperationQueue = OperationQueue.main,
        handler: @escaping () -> Void) -> NSObjectProtocol
    {
        return addObserver(forName: name, object: object, queue: queue) { _ in
            handler()
        }
    }
}
