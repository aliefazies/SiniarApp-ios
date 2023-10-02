//
//  ErrorResponse.swift
//  SiniarApp-ios
//
//  Created by Alief Ahmad Azies on 20/09/23.
//

import Foundation

struct ErrorResponse: Decodable {
    let errorMessage: String
    
    enum CodingKeys: String, CodingKey {
        case errorMessage
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        errorMessage = try values.decodeIfPresent(String.self, forKey: .errorMessage) ?? ""
    }
}
