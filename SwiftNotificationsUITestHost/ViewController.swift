import UIKit

@testable import SwiftNotifications

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet
    private weak var testResultLabel: UILabel!

    private var foundationNotificationListener: NSObjectProtocol!
    private var swiftNotificationsListener: NSObjectProtocol!

    private var foundationNotification: Notification?
    private var swiftNotification: KeyboardNotification?

    deinit {
        NotificationCenter.default.removeObserver(foundationNotificationListener)
        NotificationCenter.default.removeObserver(swiftNotificationsListener)
    }

    var test: Test! {
        didSet {
            if let swiftNotificationsListener = swiftNotificationsListener {
                NotificationCenter.default.removeObserver(swiftNotificationsListener)
            }

            if let foundationNotificationListener = foundationNotificationListener {
                NotificationCenter.default.removeObserver(foundationNotificationListener)
            }

            switch test! {
            case .willShow:
                swiftNotificationsListener = NotificationCenter.default
                    .watch { [weak self] (notification: UIKeyboardWillShowNotification) in
                        self?.record(notification)
                    }

                foundationNotificationListener =
                    NotificationCenter.default.addObserver(
                        forName: Notification.Name.UIKeyboardWillShow,
                        object: nil,
                        queue: nil,
                        using: { [weak self] notification in
                            self?.record(notification)
                        })
            case .didShow:
                swiftNotificationsListener = NotificationCenter.default
                    .watch { [weak self] (notification: UIKeyboardDidShowNotification) in
                        self?.record(notification)
                    }

                foundationNotificationListener =
                    NotificationCenter.default.addObserver(
                        forName: Notification.Name.UIKeyboardDidShow,
                        object: nil,
                        queue: nil,
                        using: { [weak self] notification in
                            self?.record(notification)
                        })
            case .willHide:
                swiftNotificationsListener = NotificationCenter.default
                    .watch { [weak self] (notification: UIKeyboardWillHideNotification) in
                        self?.record(notification)
                    }

                foundationNotificationListener =
                    NotificationCenter.default.addObserver(
                        forName: Notification.Name.UIKeyboardWillHide,
                        object: nil,
                        queue: nil,
                        using: { [weak self] notification in
                            self?.record(notification)
                        })
            case .didHide:
                swiftNotificationsListener = NotificationCenter.default
                    .watch { [weak self] (notification: UIKeyboardDidHideNotification) in
                        self?.record(notification)
                    }

                foundationNotificationListener =
                    NotificationCenter.default.addObserver(
                        forName: Notification.Name.UIKeyboardDidHide,
                        object: nil,
                        queue: nil,
                        using: { [weak self] notification in
                            self?.record(notification)
                        })
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return false
    }

    private func record(_ notification: Notification) {
        foundationNotification = notification

        compareNotificationsIfPossible()
    }

    private func record(_ notification: UIKeyboardWillShowNotification) {
        swiftNotification = notification

        compareNotificationsIfPossible()
    }

    private func record(_ notification: UIKeyboardDidShowNotification) {
        swiftNotification = notification

        compareNotificationsIfPossible()
    }

    private func record(_ notification: UIKeyboardWillHideNotification) {
        swiftNotification = notification

        compareNotificationsIfPossible()
    }

    private func record(_ notification: UIKeyboardDidHideNotification) {
        swiftNotification = notification

        compareNotificationsIfPossible()
    }

    private func compareNotificationsIfPossible() {
        guard let foundationNotification = foundationNotification, let swiftNotification = swiftNotification else {
            testResultLabel.text = "Waiting for more notifications..."

            return
        }

        guard let userInfo = foundationNotification.userInfo else {
            testResultLabel.text = "No userInfo found in foundation"

            return
        }

        guard let frameBegin = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
            testResultLabel.text = "No UIKeyboardFrameBeginUserInfoKey value found"

            return
        }

        if swiftNotification.frameBegin != frameBegin {
            testResultLabel.text = "frameBegin compare fails"

            return
        }

        guard let frameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            testResultLabel.text = "No UIKeyboardFrameEndUserInfoKey value found"

            return
        }

        if swiftNotification.frameEnd != frameEnd {
            testResultLabel.text = "frameEnd compare fails"

            return
        }

        guard let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        else {
            testResultLabel.text = "No UIKeyboardAnimationDurationUserInfoKey value found"

            return
        }

        if swiftNotification.animationDuration != animationDuration {
            testResultLabel.text = "animationDuration compare fails"

            return
        }

        guard let isCurrentApp = (userInfo[UIKeyboardIsLocalUserInfoKey] as? NSNumber)?.boolValue else {
            testResultLabel.text = "No UIKeyboardIsLocalUserInfoKey value found"

            return
        }

        if swiftNotification.isCurrentApp != isCurrentApp {
            testResultLabel.text = "isCurrentApp compare fails"

            return
        }

        testResultLabel.text = "Pass"
    }

    enum Test {
        case willShow, didShow, willHide, didHide
    }
}
