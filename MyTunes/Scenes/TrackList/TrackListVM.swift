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
    var selectRow: PublishSubject<(IndexPath, TrackCellModel)> { get set}

    func getTracks(for artist: String)
    func playMusic(model: TrackCellModel)
    func seekTrackTo(time: Int)
    func playNext()
}

class TrackListVM: MVVMViewModel {
    
    let router: MVVMRouter
    
    var tracks: PublishSubject<[TrackCellModel]> = PublishSubject<[TrackCellModel]>.init()
    var screenState: BehaviorSubject<TrackListScreenState> = BehaviorSubject<TrackListScreenState>.init(value: .loading)
    var selectRow: PublishSubject<(IndexPath, TrackCellModel)> = PublishSubject<(IndexPath, TrackCellModel)>.init()
    
    private let iTunesManager: ITunesManagerProtocol
    private let musicPlayer: MusicPlayerManagerProtocol
    private var dataSource = TrackListDataSource()
    private var playingTrackIndex: Int?
    private var nowPlaying: TrackCellModel?
    private let disposeBag = DisposeBag()
    
    init(with router: MVVMRouter, iTunesManager: ITunesManagerProtocol, musicPlayer: MusicPlayerManagerProtocol) {
        self.router = router
        self.iTunesManager = iTunesManager
        self.musicPlayer = musicPlayer
      
        musicPlayer
            .playNextTrackIfPossible
            .subscribe { (_) in
                self.playNext()
            }.disposed(by: disposeBag)
    }
    
}

extension TrackListVM: TrackListVMProtocol {
    func playNext() {
        if let index = playingTrackIndex, index + 1 < dataSource.tracks.count {
            playingTrackIndex = index + 1
            playMusic(model: dataSource.tracks[index + 1])
            selectRow.onNext((IndexPath(row: index + 1, section: 0), dataSource.tracks[index + 1]))
        }
    }
    
    func seekTrackTo(time: Int) {
        musicPlayer.seekToTime(to: time)
    }
    
    func getTracks(for artist: String) {
        playingTrackIndex = nil
        dataSource.isLoading = true
        dataSource.artist = artist
        dataSource.tracks = []
        screenState.onNext(.loading)
        fetchTracksFromServer()
    }
    
    private func fetchTracksFromServer() {
        iTunesManager
            .getTrackList(for: dataSource.artist, limit: dataSource.limit)
            .observeOn(MainScheduler.asyncInstance)
            .subscribe { (result) in
                self.dataSource.tracks.append(contentsOf: ModelTranslator.createTrackCellModelList(from: result.results))
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
    
    func playMusic(model: TrackCellModel) {
        self.nowPlaying = model
        playingTrackIndex = dataSource
            .tracks
            .firstIndex { (track) -> Bool in
                return model.trackId == track.trackId
        }
        musicPlayer.play(track: model)
    }
}

enum TrackListScreenState {
    
    case empty
    case loading
    case tracks
}

struct TrackListDataSource {
    
    var tracks: [TrackCellModel] = []
    var artist: String = ""
    var limit: Int = 25
    var isLoading: Bool = false
}
