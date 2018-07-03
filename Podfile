source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!
inhibit_all_warnings!
project 'NourTrivia.xcodeproj'

def shared_pods
    
    pod 'R.swift'
    
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxStarscream'
    pod 'RxAlamofire'
    pod 'RxAnimated'
    pod 'RxSwiftExt'

    pod 'Alamofire'
    pod 'Starscream'
    pod 'YouTubePlayer'
    
    pod 'youtube-ios-player-helper'
end

target 'NourTrivia' do
  shared_pods
end

target 'NourTriviaTests' do
    shared_pods
    pod 'Quick'
    pod 'Nimble'
end

# Workaround Cocoapods to mix Swift 3.2 and 4
# Manually add to swift3Targets, otherwise assume target uses Swift 4.4
swift3Targets = ['YouTubePlayer']
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if swift3Targets.include? target.name
                config.build_settings['SWIFT_VERSION'] = '3.3'
                else
                config.build_settings['SWIFT_VERSION'] = '4.4'
            end
        end
    end
end
