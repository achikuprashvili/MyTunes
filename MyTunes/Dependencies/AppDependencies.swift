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
    let musicPlayerManager: MusicPlayerManagerProtocol
    
    init(backendManager: BackendManager) {
        iTunesManager = ITunesManager(backendManager: backendManager)
        musicPlayerManager = MusicPlayerManager()
    }
}
