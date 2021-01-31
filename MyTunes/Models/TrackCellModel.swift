//
//  TrackCellModel.swift
//  MyTunes
//
//  Created by Archil on 1/23/21.
//

import Foundation
import RxSwift

class TrackCellModel {
    
    var trackName: String = "N/A"
    var artistName: String = "N/A"
    var collectionName: String = "N/A"
    var artworkUrl100: String? = nil
    var trackTimeSeconds: Double = 0
    var previewUrl: String = "N/A"
    var trackId: Int = 0
    var isPlaying: BehaviorSubject<Bool> = BehaviorSubject<Bool>.init(value: false)
    var isActive: BehaviorSubject<Bool> = BehaviorSubject<Bool>.init(value: false)
    var currentTime: BehaviorSubject<String> = BehaviorSubject<String>.init(value: "00:00")
    var progress: BehaviorSubject<Double> = BehaviorSubject<Double>.init(value: 0)
}
