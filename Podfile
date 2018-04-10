# Uncomment the next line to define a global platform for your project
# platform :ios, '11.2'

target 'ReactiveWeatherApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ReactiveWeatherApp
pod 'RxSwift'
pod 'RxCocoa'
pod 'SwiftyJSON'
pod 'Alamofire'
pod 'RxAlamofire'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == ‘RxSwift’
            target.build_configurations.each do |config|
                if config.name == ‘Debug’
                    config.build_settings[‘OTHER_SWIFT_FLAGS’] ||= [‘-D’, ‘TRACE_RESOURCES’]
                end
            end
        end
    end
end

end
