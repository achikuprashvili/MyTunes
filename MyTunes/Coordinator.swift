//
//  Coordinator.swift
//  MyTunes
//
//  Created by Archil on 1/18/21.
//

import Foundation
import UIKit

class Coordinator {
    
    var dependencies: AppDependencies!
    var window: UIWindow?
    var navigationController: UINavigationController
    
    init() {
        let backendManager = BackendManager()
        dependencies = AppDependencies(backendManager: backendManager)
        navigationController = UINavigationController()
    }
    
    func presentInitialScreen(on window: UIWindow) {
        self.window = window
        window.rootViewController = navigationController
        let trackListRouter = TrackListRouter(dependencies: dependencies)
        let presentationContext = TrackListRouter.PresentationContext.fromCoordinator
        trackListRouter.present(on: navigationController, animated: true, context: presentationContext, completion: nil)
        window.makeKeyAndVisible()
    }
}
