import XCTest

@testable import SweetNotifications

class SerializableNotificationTests: XCTestCase {
    private var listener: NSObjectProtocol?

    private let notificationName = Notification.Name("test")

    override func tearDown() {
        if let listener = listener {
            NotificationCenter.default.removeObserver(listener)
        }

        super.tearDown()
    }

    func testWatchForName_notificationObserverEstablished() {
        runAsyncTest { expectation in
            listener = NotificationCenter.default.watch(for: notificationName) {
                expectation.fulfill()
            }

            NotificationCenter.default.post(name: notificationName, object: nil, userInfo: nil)
        }
    }

    func testPostName_notificationDelivered() {
        runAsyncTest { expectation in
            listener = NotificationCenter.default.addObserver(
                forName: notificationName,
                object: nil,
                queue: OperationQueue.main,
                using: { _ in
                    expectation.fulfill()
                })

            NotificationCenter.default.post(notificationName)
        }
    }

    func testWatchForSerializableNotification_notificationObserverEstablished() {
        runAsyncTest { expectation in
            let expectedString = "alsdkjfaldkjf"
            let expectedNumber = 84
            listener = NotificationCenter.default.watch { (notification: TestNotification) in
                XCTAssertEqual(expectedString, notification.string)
                XCTAssertEqual(expectedNumber, notification.number)

                expectation.fulfill()
            }

            NotificationCenter.default.post(
                name: TestNotification.notificationName,
                object: nil,
                userInfo: [
                    "number": expectedNumber,
                    "string": expectedString])
        }
    }

    func testPostSerializableNotification_notificationDelivered() {
        runAsyncTest { expectation in
            let expectedString = "sljkt"
            let expectedNumber = 432

            listener = NotificationCenter.default.addObserver(
                forName: TestNotification.notificationName,
                object: nil,
                queue: OperationQueue.main,
                using: { notification in
                    guard let userInfo = notification.userInfo else {
                        XCTFail("missing userInfo")
                        return
                    }

                    XCTAssertEqual(expectedString, userInfo["string"] as? String)
                    XCTAssertEqual(expectedNumber, userInfo["number"] as? Int)
                    XCTAssertEqual(2, userInfo.count)
                    expectation.fulfill()
                })

            NotificationCenter.default.post(TestNotification(string: expectedString, number: expectedNumber))
        }
    }

    func testWatchForSerializableNotification_missingUserInfo_globalErrorHandlerCalled() {
        runAsyncTest { expectation in
            sweetNotificationsGlobalErrorHandler = { (error, _) in
                switch error {
                case NotificationSerializationError.noUserInfo:
                    // success
                    break
                default:
                    XCTFail("Unexpected error: \(error)")
                }

                expectation.fulfill()
            }

            listener = NotificationCenter.default.watch { (_: TestNotification) in
                XCTFail("Unexpected success. Expected global notification error handler to be called")

                expectation.fulfill()
            }

            NotificationCenter.default.post(
                name: TestNotification.notificationName,
                object: nil,
                userInfo: nil)
        }
    }

    func testWatchForSerializableNotification_errorIsThrownDuringSerialization_globalErrorHandlerCalled() {
        runAsyncTest { expectation in
            sweetNotificationsGlobalErrorHandler = { (error, _) in
                switch error {
                case NotificationSerializationError.missingRequiredInfo:
                    // success
                    break
                default:
                    XCTFail("Unexpected error: \(error)")
                }

                expectation.fulfill()
            }

            listener = NotificationCenter.default.watch { (_: TestNotification) in
                XCTFail("Unexpected success. Expected global notification error handler to be called")

                expectation.fulfill()
            }

            NotificationCenter.default.post(
                name: TestNotification.notificationName,
                object: nil,
                userInfo: ["string": "does not matter because number is missing"])
        }
    }

    private func runAsyncTest(testBody: (XCTestExpectation) -> Void) {
        let expectation = self.expectation(description: #function)

        testBody(expectation)

        waitForExpectations(timeout: 1) {
            if let error = $0 {
                XCTFail(error.localizedDescription)
            }
        }
    }

    private struct TestNotification: SerializableNotification, DeserializableNotification {
        let string: String
        let number: Int

        init(string: String, number: Int) {
            self.string = string
            self.number = number
        }

        init(userInfo: [AnyHashable: Any]) throws {
            guard
                let string = userInfo["string"] as? String,
                let number = userInfo["number"] as? Int else
            {
                throw NotificationSerializationError.missingRequiredInfo
            }

            self.string = string
            self.number = number
        }

        func toUserInfo() -> [AnyHashable: Any] {
            return [
                "string": string,
                "number": number]
        }
    }
}
