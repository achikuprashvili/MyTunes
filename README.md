# MyTunes  app architecture
### App architecture is MVVM+R

Each module contains VC - ViewController, VM - ViewModel, Router and Storyboard if needed.
#### App has several dependencies:
**AppDependencies** - is a protocol which contains main dependecies.
**BackendManager** - BackendManager contains main send (decodable) request which you should use to send any requests. RequestRouter is responsible for creating request. 

**Coordinator** - controls initial screens flow.

### Short description

- Language: Swift 5
- Architecture: MVVM+R
- Dependencies: 
CocoaPods
(RxSwift/RxCocoa, Alamofire, SDWebImage)
- Frameworks: UIKit, RxSwift
- Deployment Target: iOS 11.0

### Managers:
- iTunesManager - use it to retreive track list from server. Routes for iTunesManager are stored in iTunesRequestRouter.
- MusicPlayerManager - NSObject based class. Responsible for playing audio and audio controlls. Accepts TrackCellModel.

### UICompinent:
- MusicPlayerView - UIView based Object. Responsible for drawing ui and reactively update it from TrackCellModel.

### Install Guide:
- Pull code from github
- Open Terminal and navigate to the project directory. 
- Run "pod install" command.
- Open MyTunes.xcworkspace
