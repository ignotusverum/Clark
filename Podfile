source 'https://github.com/CocoaPods/Specs'
source 'https://github.com/twilio/cocoapod-specs'

# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

def shared_pods
    
    swift_version = '3.1'
    
    use_frameworks!
    
    # who cares about warnings
    inhibit_all_warnings!
    
    # Analytics
    pod 'Fabric', '1.6.8'
    pod 'Analytics', '3.5.5'
    pod 'Crashlytics', '3.8.0'
    # Segment
    pod 'Segment-Branch'
    pod 'Segment-Mixpanel'
    pod 'Segment-Facebook-App-Events'
    
    # Chat
    pod 'TwilioChatClient'
    pod 'TwilioAccessManager'
    
    # Payments
    pod 'Stripe'
    
    # Core Data
    pod 'CoreStore'
    
    # Networking
    pod 'Alamofire'
    pod 'ReachabilitySwift', '~> 3'
    
    # Storage
    pod 'AWSS3'
    
    # Keychain
    pod 'Locksmith'
    pod 'KeychainAccess'
    
    # Parsers
    pod 'Kanna'
    pod 'SwiftyJSON'
    
    # Layout
    pod 'SnapKit'
    
    #Image fetching
    pod 'Kingfisher'
    
    # Utilities
    pod 'PromiseKit'
    pod 'EZSwiftExtensions'

end

target 'Clark' do
    # Pods for Clark
    shared_pods
end

target 'Dev' do
    # Pods for Clark
    shared_pods
end

