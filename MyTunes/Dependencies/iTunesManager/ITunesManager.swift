//
//  ITunesManager.swift
//  MyTunes
//
//  Created by Archil on 1/21/21.
//

import Foundation
import RxSwift

protocol ITunesManagerProtocol: class {
    
    func getTrackList(for artist: String, limit: Int) -> Observable<TrackSearchResult>
}

class ITunesManager: BackendManager {
    
    let backendManager: BackendManager
    
    required init(backendManager: BackendManager) {
        self.backendManager = backendManager
    }
}

extension ITunesManager: ITunesManagerProtocol {
    
    func getTrackList(for artist: String, limit: Int) -> Observable<TrackSearchResult> {
        
        return Observable<TrackSearchResult>.create { observer in
            let requestRouter = ITunesRequestRouter.getTrackList(artist: artist, limit: limit)
            self.backendManager
                .sendDecodableRequest(requestRouter: requestRouter)
                .subscribe { (data) in
                    observer.onNext(data)
                } onError: { (error) in
                    observer.onError(error)
                }.disposed(by: self.disposeBag)

            return Disposables.create { }
        }
    }
}
