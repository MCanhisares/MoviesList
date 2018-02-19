//
//  ApiClient.swift
//  MoviesList
//
//  Created by Marcel Canhisares on 17/02/18.
//  Copyright © 2018 Azell. All rights reserved.
//

import Foundation
import RxSwift

enum APIClientError: Error {
    case CouldNotDecodeJSON
    case BadStatus(status: Int)
    case Other(Error)
}

extension APIClientError: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case .CouldNotDecodeJSON:
            return "Could not decode JSON"
        case let .BadStatus(status):
            return "Bad status \(status)"
        case let .Other(error):
            return "\(error)"
        }
    }
}

final class APIClient {
    private let baseURL: NSURL
    private let session: URLSession
    
    init(baseURL: NSURL, configuration: URLSessionConfiguration = .default) {
        self.baseURL = baseURL
        self.session = URLSession(configuration: configuration)
    }
    
    private func data(resource: Resource) -> Observable<Data> {
        let request = resource.requestWith(baseURL: baseURL)
        
        return Observable.create { observer in
            let task = self.session.dataTask(with: request, completionHandler: { data, response, error in
                guard error == nil else {
                    observer.onError(APIClientError.Other(error!))
                    return
                }
                
                guard let HTTPResponse = response as? HTTPURLResponse else {
                    fatalError("Couldn't get HTTP response")
                }
                
                if 200 ..< 300 ~= HTTPResponse.statusCode {
                    observer.onNext(data ?? Data())
                    observer.onCompleted()
                }
                    
                else {
                    observer.onError(APIClientError.BadStatus(status: HTTPResponse.statusCode))
                }
            })
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func objects<T: JSONDecodable>(resource: Resource) -> Observable<[T]> {
        return data(resource: resource).map { data in
            guard let objects: [T] = decode(data: data) else {
                throw APIClientError.CouldNotDecodeJSON
            }
            return objects
        }
    }
}
