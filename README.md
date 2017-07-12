# SweetNotifications
The NotificationCenter is a very useful tool. But using the API in Foundation is verbose and driven entirely by strings and values typed `Any`. Using these values every time a notification is needed is just awkward.

Using generics in Swift, we can make this much nicer, so we can focus on using the contents of a strongly typed notification.

## Quick Start
Install via CocoaPods
```ruby
pod 'SweetNotifications'
```

### UIKeyboard notifications
UIKeyboard notifications are incorporated under the subspec `SweetNotifications/UIKeyboard`. The 4 types of notifications are:
- `UIKeyboardWillShowNotification`
- `UIKeyboardDidShowNotification`
- `UIKeyboardWillHideNotification`
- `UIKeyboardDidHideNotification`

Take `UIKeyboardWillShowNotification` as an example, to register:
```swift
listener = NotificationCenter.default.watch { (notification: UIKeyboardWillShowNotification) in
    print(notification.frameBegin)
    print(notification.frameEnd)
    print(notification.animationDuration)
    print(notification.animationOption)
    print(notification.isCurrentApp)
}
```

Don't forget to deregister later:
```swift
NotificationCenter.default.removeObserver(listener)
```
__Note:__ Support for self registration coming soon

### Listening for named events only
There are notifications that don't contain a `userInfo` dictionary. In those situations we can simply watch for the named events:
```swift
listener = NotificationCenter.default.watch(for: Notification.Name.UIApplicationWillTerminate) {
    // save all the important things!
}
```
As of this moment, manual deregistration is still required.

## Custom notification types
It's easy to write your own notification types by adopting `SweetNotification`:
```swift
struct ValueChangedNotification: SweetNotification {
    let source: Source

    init(userInfo: [AnyHashable: Any]) throws {
        guard let sourceString = userInfo["source"] as? String else {
            throw SerializationError.missingSource
        }

        switch userInfo["source"] as? String {
        case "API"?:
            source = .api
        case "local"?:
            source = .local
        default:
            throw SerializationError.unknownSource(userInfo["source"] as? String ?? "<Not a string>")
        }
    }

    init(source: Source) {
        self.source = source
    }

    func toUserInfo() -> [AnyHashable: Any]? {
        switch source {
        case .api:
            return ["source": "API"]
        case .local
            return ["source": "local"]
        }
    }

    enum Source {
        case api, local
    }
}
```

### Posting custom notifications
It's all type safe again :)
```swift
let valueChangedNotification = ValueChangedNotification(source: .api)
NotificationCenter.default.post(valueChangedNotification)
```

### Unit testing
Testing custom notifications is very straight forward:
```swift
func testInitWithUserInfo_sourceStringIsValid_sourceSetCorrectly() {
    let expectedPairs: [String: ValueChangedNotification.Source] = ["API": .api, "local": .local]

    for (sourceString, expectedSource) in expectedPairs {
        let userInfo: [String: String] = ["source": sourceString]
        
        do {
            let notification = try ValueChangedNotification(userInfo: userInfo)
            XCTAssertEqual(expectedSource, notification.source)
        } catch {
            XCTFail("Unexpected failure: \(error)")
        }
    }
}
```

# Roadmap
- [ ] add global error handler
- [ ] add system notifications types
- [ ] auto-deregistration of listeners
- [ ] CI
- [ ] Carthage and SPM support(?)
- [ ] cross platform support(?)