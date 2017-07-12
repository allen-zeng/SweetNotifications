public class UIKeyboardWillShowNotification: KeyboardNotification, DeserializableNotification {
    public static var notificationName: Notification.Name {
        return Notification.Name.UIKeyboardWillShow
    }
}

public class UIKeyboardDidShowNotification: KeyboardNotification, DeserializableNotification {
    public static var notificationName: Notification.Name {
        return Notification.Name.UIKeyboardDidShow
    }
}

public class UIKeyboardWillHideNotification: KeyboardNotification, DeserializableNotification {
    public static var notificationName: Notification.Name {
        return Notification.Name.UIKeyboardWillHide
    }
}

public class UIKeyboardDidHideNotification: KeyboardNotification, DeserializableNotification {
    public static var notificationName: Notification.Name {
        return Notification.Name.UIKeyboardDidHide
    }
}

open class KeyboardNotification {
    private let properties: UIKeyboardNotificationProperties

    public required init(userInfo: [AnyHashable: Any]) throws {
        properties = try UIKeyboardNotificationProperties(userInfo)
    }

    public var frameBegin: CGRect {
        return properties.frameBegin
    }

    public var frameEnd: CGRect {
        return properties.frameEnd
    }

    public var animationDuration: Double {
        return properties.animationDuration
    }

    public var animationOption: UIViewAnimationOptions {
        return properties.animationOption
    }

    public var isCurrentApp: Bool {
        return properties.isCurrentApp
    }
}

fileprivate struct UIKeyboardNotificationProperties {
    init(_ userInfo: [AnyHashable: Any]) throws {
        guard let frameBegin = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
            throw NotificationSerializationError.missingRequiredInfo
        }

        guard let frameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            throw NotificationSerializationError.missingRequiredInfo
        }

        guard let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        else {
            throw NotificationSerializationError.missingRequiredInfo
        }

        guard let curve =
                ((userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue)
                    .flatMap(UIViewAnimationCurve.init)
            else {
                throw NotificationSerializationError.missingRequiredInfo
            }

        guard let isCurrentApp = (userInfo[UIKeyboardIsLocalUserInfoKey] as? NSNumber)?.boolValue else {
            throw NotificationSerializationError.missingRequiredInfo
        }

        self.frameBegin = frameBegin
        self.frameEnd = frameEnd

        self.animationDuration = animationDuration

        switch curve {
        case .easeInOut:
            animationOption = .curveEaseInOut
        case .easeIn:
            animationOption = .curveEaseIn
        case .easeOut:
            animationOption = .curveEaseOut
        case .linear:
            animationOption = .curveLinear
        }

        self.isCurrentApp = isCurrentApp
    }

    let frameBegin: CGRect
    let frameEnd: CGRect

    let animationDuration: Double

    let animationOption: UIViewAnimationOptions

    let isCurrentApp: Bool
}
