//
//  Movie.swift
//  MoviesList
//
//  Created by Marcel Canhisares on 17/02/18.
//  Copyright © 2018 Azell. All rights reserved.
//

import Foundation

class BasicMovie: JSONDecodable {
    let id: Int
    let title: String
    let voteAvg: Float?
    let voteCount: Int?
    let popularity: Float?
    let posterImgPath: String?
    let backdropImgPath: String?
    let originalLanguage: String
    let overview: String
    let releaseDate: Date?
    
    required init?(dictionary: JSONDictionary) {
        guard let id = dictionary["id"] as? Int ,
            let title = dictionary["title"] as? String else {
            return nil
        }
        self.id = id
        self.title = title
        self.voteAvg = dictionary["vote_average"] as? Float
        self.voteCount = dictionary["vote_count"] as? Int
        self.popularity = dictionary["popularity"] as? Float
        self.posterImgPath = dictionary["poster_path"] as? String
        self.backdropImgPath = dictionary["backdrop_path"] as? String
        self.originalLanguage = (dictionary["original_language"] as? String ?? "").uppercased()
        self.overview = dictionary["overview"] as? String ?? ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        self.releaseDate = dateFormatter.date(from: dictionary["release_date"] as? String ?? "")
    }
}

class Movie: BasicMovie {
    let adult: Bool?
    let budget: Int?
    let genres: [String]?
    let productionCompanies: [String]?
    let productionCountries: [String]?
    let revenue: Int?
    let spokenLanguages: [String]?
    let releaseStatus: String
    
    required init?(dictionary: JSONDictionary) {
        self.adult = dictionary["adult"] as? Bool
        self.budget = dictionary["budget"] as? Int
        self.genres = (dictionary["genres"] as? [[String: String]])?.flatMap{
            $0["name"]
        }
        self.productionCompanies = (dictionary["production_companies"] as? [[String: String]])?.flatMap{
            $0["name"]
        }
        self.productionCountries = (dictionary["productionCountries"] as? [[String: String]])?.flatMap{
            $0["name"]
        }
        self.revenue = dictionary["revenue"] as? Int
        self.spokenLanguages = (dictionary["spoken_languages"] as? [[String: String]])?.flatMap{
            $0["name"]
        }
        self.releaseStatus = dictionary["status"] as? String ?? ""
        super.init(dictionary: dictionary)
    }
}

