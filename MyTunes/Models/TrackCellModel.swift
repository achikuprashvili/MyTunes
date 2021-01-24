//
//  TrackCellModel.swift
//  MyTunes
//
//  Created by Archil on 1/23/21.
//

import Foundation
import RxSwift

struct TrackCellModel {
    
    var trackName: String = "N/A"
    var artistName: String = "N/A"
    var collectionName: String = "N/A"
    var artworkUrl100: String? = nil
    var trackTimeMillis: Int = 0
    var previewUrl: String = "N/A"
    var trackId: Int = 0
    var isPlaying: BehaviorSubject<Bool> = BehaviorSubject<Bool>.init(value: false)
}
