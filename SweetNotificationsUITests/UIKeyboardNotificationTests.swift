import XCTest

@testable import SweetNotifications

class UIKeyboardNotificationTests: XCTestCase {
    override func setUp() {
        super.setUp()

        continueAfterFailure = false

        XCUIApplication().launch()
    }

    func testUIKeyboardWillShowNotification_propertiesDeserialisedCorrectly() {
        let app = XCUIApplication()
        app.buttons["Keyboard will show"].tap()

        verifyPass(in: app)
    }

    func testUIKeyboardDidShowNotification_propertiesDeserialisedCorrectly() {
        let app = XCUIApplication()
        app.buttons["Keyboard did show"].tap()

        verifyPass(in: app)
    }

    func testUIKeyboardWillHideNotification_propertiesDeserialisedCorrectly() {
        let app = XCUIApplication()
        app.buttons["Keyboard will hide"].tap()

        verifyPassForHideTests(in: app)
    }

    func testUIKeyboardDidHideNotification_propertiesDeserialisedCorrectly() {
        let app = XCUIApplication()
        app.buttons["Keyboard did hide"].tap()

        verifyPassForHideTests(in: app)
    }

    private func verifyPassForHideTests(in app: XCUIApplication) {
        app.otherElements.containing(.staticText, identifier:"No keyboard detected")
            .children(matching: .textField).element
            .tap()

        app.buttons["Return"].tap()

        _ = expectation(
            for: NSPredicate(format: "exists == true"),
            evaluatedWith: app.staticTexts["Pass"],
            handler: nil)

        waitForExpectations(timeout: 1, handler: nil)
    }

    private func verifyPass(in app: XCUIApplication) {
        app.otherElements.containing(.staticText, identifier:"No keyboard detected")
            .children(matching: .textField).element
            .tap()

        _ = expectation(
            for: NSPredicate(format: "exists == true"),
            evaluatedWith: app.staticTexts["Pass"],
            handler: nil)

        waitForExpectations(timeout: 1, handler: nil)
    }
}
