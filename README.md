# RxMvvmWeatherApp
App is based on MVVM architecture. It uses RxSwift as a communication method between each layers: View, ViewModel and Model. For example, user interactions are delivered from View to ViewModel via PublishSubject, data is exposed by properties or Observable properties. For web requests RxAlamofire is used. For DI Swinject is used.

RxSwift:      https://github.com/ReactiveX/RxSwift<br />
RxAlamofire:  https://github.com/RxSwiftCommunity/RxAlamofire<br />
SwiftyJSON:   https://github.com/SwiftyJSON/SwiftyJSON
Swinject:     https://github.com/Swinject/Swinject

For Unit Tests:<br />
Nimble:       https://github.com/Quick/Nimble
Quick:        https://github.com/Quick/Quick
RxBlocking:   https://github.com/ReactiveX/RxSwift/tree/master/RxBlocking
