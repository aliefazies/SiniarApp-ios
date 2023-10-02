//
//  SearchResponse.swift
//  SiniarApp-ios
//
//  Created by Alief Ahmad Azies on 20/09/23.
//

import Foundation

struct SearchResponse: Decodable {
    let resultCount: Int
    let results: [Podcast]
    
    enum CodingKeys: String, CodingKey {
        case resultCount
        case results
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        resultCount = try values.decodeIfPresent(Int.self, forKey: .resultCount) ?? 0
        results = try values.decodeIfPresent([Podcast].self, forKey: .results) ?? []
    }
}
