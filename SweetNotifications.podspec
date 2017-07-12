Pod::Spec.new do |s|
  s.name             = "SweetNotifications"
  s.version          = `agvtool mvers -terse1`
  s.summary          = "Serializable notifications for iOS Notification Center"
  s.description      = "Do away with Notification Center's weak stringly typed API."
  s.homepage         = 'https://github.com/allen-zeng/SweetNotifications'
  s.license          = 'MIT'
  s.author           = { "Allen Zeng" => "allenzeng@outlook.com" }
  s.source           = {
    :git => "https://github.com/allen-zeng/SweetNotifications.git",
    :tag => s.version }

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.subspec 'Core' do |ss|
    ss.source_files = 'SweetNotifications/*.swift'
    ss.frameworks = 'Foundation'
  end

  s.subspec 'UIKeyboard' do |ss|
    ss.ios.source_files = 'SweetNotifications/UIKeyboardNotifications/*.swift'
    ss.ios.frameworks = 'UIKit'
    ss.dependency 'SweetNotifications/Core'
  end
end
