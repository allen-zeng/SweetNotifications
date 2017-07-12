public var sweetNotificationsGlobalErrorHandler: (Error, String) -> Void = {
    print("There was an error (de)serializing \($1): \($0)")
}
