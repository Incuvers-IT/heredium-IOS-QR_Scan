//
//  Projects.swift
//  app
//
//  Created by Muune on 2023/03/07.
//

import Foundation


enum ProjectResponse : Decodable {
    case success([Project])
    case failure(ErrorData)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = .success(try container.decode([Project].self))
        } catch {
            self = .failure(try container.decode(ErrorData.self))
        }
    }
}



// MARK: - User
struct Project: Codable {
    let id: Int
    let kind: String
    let title: String
    let startDate: String
    let endDate: String
    let isCheck: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id
        case kind
        case title
        case startDate
        case endDate
        case isCheck
    }
}


