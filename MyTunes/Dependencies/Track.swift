//
//  Track.swift
//  MyTunes
//
//  Created by Archil on 1/21/21.
//

import Foundation
struct Track: Codable {

    var trackName: String
    var artistName: String
    var artworkUrl100: String?
    var trackTimeMillis: Int?
    var previewUrl: String
}

struct TrackSearchResult: Codable {
    var resultCount: Int
    var results: [Track]
}
