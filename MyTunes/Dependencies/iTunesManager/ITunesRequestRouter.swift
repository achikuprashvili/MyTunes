//
//  ITunesRequestRouter.swift
//  MyTunes
//
//  Created by Archil on 1/21/21.
//

import Foundation
import Alamofire

fileprivate enum ParameterKey: String {
    case page
    case limit
    case term
    case media
    case attribute
}

enum ITunesRequestRouter: RequestRouter {
    
    case getArtists(searchText: String, page: Int, limit: Int)
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var path: String {
        switch self {
        default:
            return "search"
        }
    }
    
    var parameters: Parameters? {
        
        switch self {
        case .getArtists(let searchText, let page, let limit):
            return [
                ParameterKey.term.rawValue: searchText.replacingOccurrences(of: " ", with: "+"),
                ParameterKey.page.rawValue: page,
                ParameterKey.limit.rawValue: limit,
                ParameterKey.media.rawValue: "music",
                ParameterKey.attribute.rawValue: "artistTerm"
            ]
        }
        
    }

}
