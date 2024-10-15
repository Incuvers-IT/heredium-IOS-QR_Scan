//
//  Allow.swift
//  app
//
//  Created by Muune on 2023/03/07.
//

import Foundation

// MARK: - User
struct Allow: Codable {
    let id: Int
    let kind: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case kind
    }
}


