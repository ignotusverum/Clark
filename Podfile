source 'https://github.com/CocoaPods/Specs'
source 'https://github.com/twilio/cocoapod-specs'

# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

def shared_pods
    
    use_frameworks!
    
    # who cares about warnings
    inhibit_all_warnings!
    
    # Analytics
    pod 'Fabric'
    pod 'Analytics'
    pod 'Crashlytics'
    
    pod 'Segment-Branch'
    pod 'Segment-Mixpanel'
    pod 'Segment-Facebook-App-Events'
    
    pod 'AppsFlyerFramework'
    pod 'segment-appsflyer-ios/StaticLibWorkaround'
    
    # Transition Animation
    pod 'Hero', '1.0.0-alpha.4'
    pod 'Popover', '1.1.0'
    pod 'Presentr', '1.2.3'
    
    # Alerts
    pod 'SwiftMessages'
    
    # phone formatting
    pod 'PhoneNumberKit', '~> 1.3'
    
    # Defaults
    pod 'Locksmith'
    
    # Photo viewer
    pod 'SKPhotoBrowser', '4.1.1'
    
    # Parallax
    pod 'ParallaxHeader', '1.0.6'
    
    # Empty view
    pod 'DZNEmptyDataSet'
    
    # Chat
    pod 'TwilioAccessManager'
    pod 'TwilioChatClient', '2.0.1'
    
    # Payments
    pod 'Stripe'
     
    # Chat
    pod 'NMessenger', :git => 'https://github.com/hiclark/NMessenger.git', :branch => 'bugfix/keyboard-whitespace-tabbar'
    
    # Core Data
    pod 'CoreStore'
    
    # Text view + placeholer 
    pod 'UITextView+Placeholder', '~> 1.2'
    
    # Keyboard scrolling
    pod 'IQKeyboardManagerSwift'
    
    # Calendar
    pod 'FSCalendar'
    
    # Networking
    pod 'Alamofire'
    pod 'ReachabilitySwift', '~> 3'
    
    # Storage
    pod 'AWSS3'
    
    # Progress
    pod 'SVProgressHUD'
    
    # Keychain
    pod 'Locksmith'
    pod 'KeychainAccess'
    
    # Parsers
    pod 'Kanna'
    pod 'SwiftyJSON', '3.1.4'
    
    # Layout
    pod 'SnapKit', '3.2.0'
    
    #Image fetching
    pod 'Kingfisher', '3.13.1'
    
    # Utilities
    pod 'PromiseKit'
    pod 'EZSwiftExtensions'

end

target 'Clark' do
    # Pods for Clark
    shared_pods
end

target 'ClarkUITest' do
    # Pods for Clark
    shared_pods
end

target 'ClarkUnitTest' do
    # Pods for Clark
    shared_pods
end

target 'Dev' do
    # Pods for Clark
    shared_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = "YES"
            config.build_settings['SWIFT_VERSION'] = '3.2'
        end
    end
end
