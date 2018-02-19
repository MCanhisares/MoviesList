//
//  MovieApi.swift
//  MoviesList
//
//  Created by Marcel Canhisares on 17/02/18.
//  Copyright © 2018 Azell. All rights reserved.
//

import Foundation
import RxSwift

enum MovieApi {
    case Upcoming(page: Int)
    case Details(id: Int)
}

extension MovieApi: Resource {
    
    var apiKey : String {
        return "1f54bd990f1cdfb230adb312546d765d"
    }
    
    var parameters: [String : String] {
        switch self {
        case let .Upcoming(page: page) :
            return ["api_key" : self.apiKey,
                    "page" : String(page)]
        case .Details:
            return ["api_key" : self.apiKey]
        }
    }
    
    
    var path : String {
        switch self {
        case .Upcoming:
            return "/movie/upcoming"
        case let .Details(id: id):
            return "/movie/\(id)"
        }
    }
}

extension NSURL {
    class func moviesURL() -> NSURL {
        return NSURL(string: "https://api.themoviedb.org/3")!
    }
}

extension APIClient {
    class func MovieAPIClient() -> APIClient {
        return APIClient(baseURL: NSURL.moviesURL())
    }
    
    func movieDetailWithId(id: Int) -> Observable<Movie> {
        return object(resource: MovieApi.Details(id: id))
    }
    
    func upcomingMoviesForPage(page: Int) -> Observable<[Movie]> {
        return objects(resource: MovieApi.Upcoming(page: page))
    }
    
    func upcomingMoviesForPage(page: Int) -> Observable<Movie> {
        return object(resource: MovieApi.Upcoming(page: page))
    }
}
