//
//  AppDependencies.swift
//  MyTunes
//
//  Created by Archil on 1/18/21.
//

import Foundation
import UIKit

struct AppDependencies {
    let iTunesManager: ITunesManagerProtocol
    
    init(backendManager: BackendManager) {
        iTunesManager = ITunesManager(backendManager: backendManager)
    }
}
