Pod::Spec.new do |s|
  s.name             = "SwiftNotifications"
  s.version          = `agvtool mvers -terse1`
  s.summary          = "Serializable notifications for iOS Notification Center"
  s.description      = "Do away with Notification Center's weak stringly typed API."
  s.homepage         = 'https://github.com/allen-zeng/SwiftNotifications'
  s.license          = 'MIT'
  s.author           = { "Allen Zeng" => "allenzeng@outlook.com" }
  s.source           = {
    :git => "https://github.com/allen-zeng/SwiftNotifications.git",
    :tag => s.version }

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'SwiftNotifications/*.swift'

end
