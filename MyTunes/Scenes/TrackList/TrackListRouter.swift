//
//  TrackListRouter.swift
//  MyTunes
//
//  Created by Archil on 1/21/21.
//

import Foundation
import UIKit

class TrackListRouter: MVVMRouter {
    
    enum PresentationContext {
        case fromCoordinator
    }
    
    enum RouteType {
        
    }
    
    weak var baseViewController: UIViewController?
    let dependencies: AppDependencies
    
    init(dependencies: AppDependencies) {
        self.dependencies = dependencies
    }
    
    func present(on baseVC: UIViewController, animated: Bool, context: Any?, completion: ((Bool) -> Void)?) {
        
        guard let presentationContext = context as? PresentationContext else {
            assertionFailure("The context type missmatch")
            return
        }
        
        guard let nc = baseVC as? UINavigationController else {
            assertionFailure("The baseVC should be UINavigationController")
            return
        }
        baseViewController = baseVC
        
        let vc = TrackListVC.instantiateFromStoryboard(storyboardName: "TrackList", storyboardId: "TrackListVC")
        let viewModel = TrackListVM.init(with: self, iTunesManager: dependencies.iTunesManager, musicPlayer: dependencies.musicPlayerManager)
        vc.viewModel = viewModel
        
        switch presentationContext {
        
        case .fromCoordinator:
            nc.viewControllers = [vc]
        }
    }
    
    //==============================================================================
    
    func enqueueRoute(with context: Any?, animated: Bool, completion: ((Bool) -> Void)?) {
        guard let routeType = context as? RouteType else {
            assertionFailure("The route type missmatches")
            return
        }
        
        guard let _ = baseViewController as? UINavigationController else {
            assertionFailure("The baseVC should be UINavigationController")
            return
        }
        
        switch routeType {
            
        }
    }
    
    //==============================================================================
    
    func dismiss(animated: Bool, context: Any?, completion: ((Bool) -> Void)?) {
        guard let nc = baseViewController as? UINavigationController else {
            assertionFailure("The baseVC should be UINavigationController")
            return
        }
        nc.popViewController(animated: true)
    }
    
    //==============================================================================
}
