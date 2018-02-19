//
//  JSONDecodable.swift
//  MoviesList
//
//  Created by Marcel Canhisares on 17/02/18.
//  Copyright © 2018 Azell. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: AnyObject]

protocol JSONDecodable {
    init?(dictionary: JSONDictionary)
}

func decode<T: JSONDecodable>(dictionaries: [JSONDictionary]) -> [T] {
    return dictionaries.flatMap { T(dictionary: $0) }
}

func decode<T: JSONDecodable>(dictionary: JSONDictionary) -> T? {
    return T(dictionary: dictionary)
}

func decode<T:JSONDecodable>(data: Data) -> T? {
    guard let JSONObject = try? JSONSerialization.jsonObject(with: data, options: []),
        let dictionary = JSONObject as? JSONDictionary else {
            return nil
    }
    
    return decode(dictionary: dictionary)
}

func decode<T:JSONDecodable>(data: Data) -> [T]? {
    guard let JSONObject = try? JSONSerialization.jsonObject(with: data, options: []),
        let dictionaries = JSONObject as? [JSONDictionary] else {
            return nil
    }
    
    return decode(dictionaries: dictionaries)
}
