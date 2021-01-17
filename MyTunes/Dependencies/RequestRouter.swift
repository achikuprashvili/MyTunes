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
        var urlRequest = URLRequest(url: url)
        let httpBody = try! JSONSerialization.data(withJSONObject: parameters as Any, options: .prettyPrinted)
        urlRequest.httpBody = httpBody
        urlRequest.httpMethod = method.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        return urlRequest
    }
}
