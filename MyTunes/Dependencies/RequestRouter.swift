//
//  RequestRouter.swift
//  MyTunes
//
//  Created by Archil on 1/18/21.
//

import Foundation
import Alamofire

protocol RequestRouter: URLRequestConvertible {
    
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
}

extension RequestRouter {
    
    func asURLRequest() throws -> URLRequest {
        
        let url = try Constants.baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        urlRequest.httpMethod = method.rawValue
        urlRequest.addValue("text/javascript", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("text/javascript", forHTTPHeaderField: "Accept")
        
        return urlRequest
    }
}
