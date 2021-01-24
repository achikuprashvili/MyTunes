//
//  TrackListVM.swift
//  MyTunes
//
//  Created by Archil on 1/21/21.
//

import Foundation
import RxSwift

// MARK:- Protocol

protocol TrackListVMProtocol {
    var tracks: PublishSubject<[TrackCellModel]> { get set }
    var screenState: BehaviorSubject<TrackListScreenState> { get set }
    
    func getTracksNextPage()
    func getTracks(for artist: String)
}

class TrackListVM: MVVMViewModel {
    
    let router: MVVMRouter
    
    var tracks: PublishSubject<[TrackCellModel]> = PublishSubject<[TrackCellModel]>.init()
    var screenState: BehaviorSubject<TrackListScreenState> = BehaviorSubject<TrackListScreenState>.init(value: .loading)
    
    let iTunesManager: ITunesManagerProtocol
    let disposeBag = DisposeBag()
    var dataSource = TrackListDataSource()
    
    init(with router: MVVMRouter, iTunesManager: ITunesManagerProtocol) {
        self.router = router
        self.iTunesManager = iTunesManager
        getTracks(for: "2pac")
    }
    
}

extension TrackListVM: TrackListVMProtocol {
    
    func getTracksNextPage() {
        if dataSource.isLoading {
            return
        }
        
        screenState.onNext(.loadingMore)
        fetchTracksFromServer()
    }
    
    func getTracks(for artist: String) {
        dataSource.isLoading = true
        dataSource.artist = artist
        dataSource.page = 0
        dataSource.tracks = []
        dataSource.shouldLoadMore = true
        screenState.onNext(.loading)
        fetchTracksFromServer()
    }
    
    private func fetchTracksFromServer() {
        if !dataSource.shouldLoadMore {
            return
        }
        iTunesManager.getTrackList(for: dataSource.artist, page: dataSource.page, limit: dataSource.limit).observeOn(MainScheduler.asyncInstance).subscribe { (result) in
            
            self.dataSource.tracks.append(contentsOf: ModelTranslator.createTrackCellModelList(from: result.results))
            if result.results.count == 0 {
                self.dataSource.shouldLoadMore = false
            } else {
                self.dataSource.page += 1
            }
            self.finilizeSearch()
            
        } onError: { (error) in
            
            self.finilizeSearch()
            
        }.disposed(by: disposeBag)
    }
    
    private func finilizeSearch() {
        dataSource.tracks.count == 0 ? screenState.onNext(.empty) : screenState.onNext(.tracks)
        dataSource.isLoading = false
        tracks.onNext(dataSource.tracks)
    }
}

enum TrackListScreenState {
    
    case empty
    case loading
    case tracks
    case loadingMore
}

struct TrackListDataSource {
    
    var tracks: [TrackCellModel] = []
    var artist: String = ""
    var page: Int = 0
    var limit: Int = 20
    var isLoading: Bool = false
    var shouldLoadMore: Bool = true
}
