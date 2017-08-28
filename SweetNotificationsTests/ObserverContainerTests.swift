import XCTest

@testable import SweetNotifications

let testNotificationGlobalErrorHandler: (Error, String) -> Void = {
    XCTFail("There was an error (de)serializing \($1): \($0)")
}

class ObserverContainerTests: XCTestCase {
    override func setUp() {
        super.setUp()

        sweetNotificationsGlobalErrorHandler = testNotificationGlobalErrorHandler
    }

    func testObserverContainer() {
        var notificationHits = 0

        // register observers
        let observer = NotificationCenter.default.watch { (_: TestNotification) in
            notificationHits += 1
        }

        // add observers to container
        var container: ObserverContainer? = ObserverContainer(observers: [observer])

        XCTAssertTrue(observer === container?.observers.first)

        // verify registration by sending notifications
        NotificationCenter.default.post(TestNotification())

        XCTAssertEqual(1, notificationHits)

        // set container to nil
        container = nil

        // verify by sending notifications to see that they are not being watched
        NotificationCenter.default.post(TestNotification())

        XCTAssertEqual(1, notificationHits)
    }
}

private struct TestNotification: SweetNotification {
    init() { }

    init(userInfo: [AnyHashable: Any]) throws {
        self.init()
    }

    func toUserInfo() -> [AnyHashable: Any]? {
        return [:]
    }
}
