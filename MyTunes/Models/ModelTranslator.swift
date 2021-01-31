//
//  ModelTranslator.swift
//  MyTunes
//
//  Created by Archil on 1/23/21.
//

import Foundation

protocol ModelTranslatorProtocol {
    
    static func createTrackCellModel(from track: Track) -> TrackCellModel
    static func createTrackCellModelList (from trackList: [Track]) -> [TrackCellModel]
}

class ModelTranslator: ModelTranslatorProtocol {
    
    static func createTrackCellModel(from track: Track) -> TrackCellModel {
       
        let result = TrackCellModel()
        result.trackName = track.trackName
        result.artistName = track.artistName
        result.artworkUrl100 = track.artworkUrl100
        result.trackTimeSeconds = Double(track.trackTimeMillis) / 1000
        result.previewUrl = track.previewUrl
        result.trackId = track.trackId
        result.collectionName = track.collectionName
        return result
    }
    
    static func createTrackCellModelList (from trackList: [Track]) -> [TrackCellModel] {
        
        let result: [TrackCellModel] = trackList.map { (track) -> TrackCellModel in
            let trackCellModel = createTrackCellModel(from: track)
            return trackCellModel
        }
        
        return result
    }
    
}
