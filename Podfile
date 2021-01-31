# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MyTunes' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      end
    end
  end

  # Pods for MyTunes
  pod 'RxSwift', '~> 5.1.1'
  pod 'RxCocoa', '~> 5.1.1'
  pod 'Alamofire', '~> 5.2.2'
  pod 'SDWebImage', '~> 5.9.0'
end
