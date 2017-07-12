import UIKit

@testable import SweetNotifications

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet
    private weak var testResultLabel: UILabel!

    private var foundationNotificationListener: NSObjectProtocol!
    private var SweetNotificationsListener: NSObjectProtocol!

    private var foundationNotification: Notification?
    private var SweetNotification: KeyboardNotification?

    deinit {
        NotificationCenter.default.removeObserver(foundationNotificationListener)
        NotificationCenter.default.removeObserver(SweetNotificationsListener)
    }

    var test: Test! {
        didSet {
            if let SweetNotificationsListener = SweetNotificationsListener {
                NotificationCenter.default.removeObserver(SweetNotificationsListener)
            }

            if let foundationNotificationListener = foundationNotificationListener {
                NotificationCenter.default.removeObserver(foundationNotificationListener)
            }

            switch test! {
            case .willShow:
                SweetNotificationsListener = NotificationCenter.default
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
                SweetNotificationsListener = NotificationCenter.default
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
                SweetNotificationsListener = NotificationCenter.default
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
                SweetNotificationsListener = NotificationCenter.default
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
        SweetNotification = notification

        compareNotificationsIfPossible()
    }

    private func record(_ notification: UIKeyboardDidShowNotification) {
        SweetNotification = notification

        compareNotificationsIfPossible()
    }

    private func record(_ notification: UIKeyboardWillHideNotification) {
        SweetNotification = notification

        compareNotificationsIfPossible()
    }

    private func record(_ notification: UIKeyboardDidHideNotification) {
        SweetNotification = notification

        compareNotificationsIfPossible()
    }

    private func compareNotificationsIfPossible() {
        guard let foundationNotification = foundationNotification, let SweetNotification = SweetNotification else {
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

        if SweetNotification.frameBegin != frameBegin {
            testResultLabel.text = "frameBegin compare fails"

            return
        }

        guard let frameEnd = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            testResultLabel.text = "No UIKeyboardFrameEndUserInfoKey value found"

            return
        }

        if SweetNotification.frameEnd != frameEnd {
            testResultLabel.text = "frameEnd compare fails"

            return
        }

        guard let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        else {
            testResultLabel.text = "No UIKeyboardAnimationDurationUserInfoKey value found"

            return
        }

        if SweetNotification.animationDuration != animationDuration {
            testResultLabel.text = "animationDuration compare fails"

            return
        }

        guard let isCurrentApp = (userInfo[UIKeyboardIsLocalUserInfoKey] as? NSNumber)?.boolValue else {
            testResultLabel.text = "No UIKeyboardIsLocalUserInfoKey value found"

            return
        }

        if SweetNotification.isCurrentApp != isCurrentApp {
            testResultLabel.text = "isCurrentApp compare fails"

            return
        }

        testResultLabel.text = "Pass"
    }

    enum Test {
        case willShow, didShow, willHide, didHide
    }
}
