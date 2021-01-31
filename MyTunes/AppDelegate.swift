//
//  AppDelegate.swift
//  MyTunes
//
//  Created by Archil on 1/18/21.
//

import UIKit
import MediaPlayer
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let coordinator = Coordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 13.0, *) {
            // Check SceneDelegate
        } else {
            coordinator.presentInitialScreen(on: UIWindow())
        }
        
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, policy: AVAudioSession.RouteSharingPolicy.default, options: [.allowAirPlay])
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

