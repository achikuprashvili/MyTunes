//
//  TrackListVM.swift
//  MyTunes
//
//  Created by Archil on 1/21/21.
//

import Foundation

// MARK:- Protocol

protocol TrackListVMProtocol {
    
}

class TrackListVM: MVVMViewModel {
    
    let router: MVVMRouter
    let iTunesManager: ITunesManagerProtocol
    
    //==============================================================================
    
    init(with router: MVVMRouter, iTunesManager: ITunesManagerProtocol) {
        self.router = router
        self.iTunesManager = iTunesManager
    }
    
    //==============================================================================
}

extension TrackListVM: TrackListVMProtocol {
    
}
