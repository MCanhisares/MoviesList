//
//  ApiResource.swift
//  MoviesList
//
//  Created by Marcel Canhisares on 17/02/18.
//  Copyright © 2018 Azell. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case PUT = "PUT"
    case GET = "GET"
    case POST = "POST"
    case DELETE = "DELETE"
}

protocol Resource {    
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: [String: String] { get }
}


extension Resource {
    
    var method: HTTPMethod {
        return .GET
    }
    
    func requestWith(baseURL: NSURL) -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
        // NSURLComponents can fail due to programming errors, so
        // prefer crashing than returning an optional
        
        guard var components = URLComponents(url: url!, resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components from \(String(describing: url))")
        }
        
        components.queryItems = parameters.map {
            URLQueryItem(name: String($0), value: String($1))
        }
        
        guard let finalURL = components.url else {
            fatalError("Unable to retrieve final URL")
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        
        return request
    }
}
