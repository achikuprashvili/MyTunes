//
//  MusicPlayerManager.swift
//  MyTunes
//
//  Created by Archil on 1/24/21.
//

import Foundation
import MediaPlayer
import RxSwift
import RxCocoa

protocol MusicPlayerManagerProtocol {
    var playNextTrackIfPossible: PublishSubject<Void> { get set }
    func play(track: TrackCellModel)
    func play()
    func pause()
    func seekToTime(to seconds: Int)
}

class MusicPlayerManager: NSObject {

    let disposeBag = DisposeBag()
    private var musicPlayer: AVPlayer
    private var currentTrack: TrackCellModel?
    private var playerItem: AVPlayerItem?
    private var progressMonitoringDisposable: Disposable?
    var playNextTrackIfPossible: PublishSubject<Void> = PublishSubject<Void>.init()
    
    
    override init() {
        musicPlayer = AVPlayer()
        musicPlayer.actionAtItemEnd = .pause
    }
    
    @objc func itemDidPlayToEnd( _ notification: NSNotification) {
        currentTrack?.isPlaying.onNext(false)
        seekToTime(to: 0)
        playNextTrackIfPossible.onNext(())
    }
    
    private func addProgressObserver() {
        progressMonitoringDisposable = Observable<Int>
            .interval(.milliseconds(200), scheduler: MainScheduler.instance)
            .subscribe(onNext: { observer in
                let currentProgressInSeconds = CMTimeGetSeconds(self.musicPlayer.currentTime())
                let durationInSeconds = CMTimeGetSeconds(self.musicPlayer.currentItem!.duration)
                self.currentTrack?.progress.onNext(currentProgressInSeconds / durationInSeconds)
                self.currentTrack?.currentTime.on(.next(currentProgressInSeconds.minuteSecond))
            })
    }
    
    private func addPlayToEndObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.itemDidPlayToEnd(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    
    private func removeObservers() {
        progressMonitoringDisposable?.dispose()
    }
}

extension MusicPlayerManager: MusicPlayerManagerProtocol {
    
    func play() {
        musicPlayer.play()
    }
    
    func pause() {
        musicPlayer.pause()
    }
    
    func seekToTime(to seconds: Int) {
        let time = CMTime(value: CMTimeValue(seconds), timescale: 1)
        musicPlayer.seek(to: time)
    }
    
    func play(track: TrackCellModel) {
        if currentTrack?.trackId == track.trackId {
            let isPlaying = (try? currentTrack?.isPlaying.value()) ?? false
            if isPlaying {
                musicPlayer.pause()
                currentTrack?.isPlaying.onNext(false)
            } else {
                musicPlayer.play()
                currentTrack?.isPlaying.onNext(true)
            }
            return
        }
        removeObservers()
        currentTrack?.isPlaying.onNext(false)
        currentTrack = track
        playerItem = AVPlayerItem(url: URL(string: track.previewUrl)!)
        self.musicPlayer = AVPlayer(playerItem: playerItem)
        addPlayToEndObserver()
        addProgressObserver()
        musicPlayer.play()
        currentTrack?.isPlaying.onNext(true)
    }
    
}

extension Float64 {
    var minuteSecond: String {
        String(format:"%02d:%02d", Int(self / 60), Int(self.truncatingRemainder(dividingBy: 60)))
    }
}

