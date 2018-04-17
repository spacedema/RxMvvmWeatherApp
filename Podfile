platform :ios, '11.3'
use_frameworks!

def testing_pods
    pod 'Quick'
    pod 'Nimble'
    pod 'RxBlocking' 
end

def common_pods
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'SwiftyJSON'
    pod 'Alamofire'
    pod 'RxAlamofire'
    pod 'PKHUD'
    pod 'Swinject'
end

target 'ReactiveWeatherApp' do
    common_pods

target 'ReactiveWeatherAppTests' do
    testing_pods
end

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
