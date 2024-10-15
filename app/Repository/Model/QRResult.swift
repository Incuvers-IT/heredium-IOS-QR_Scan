//
//  QRResult.swift
//  app
//
//  Created by Muune on 2023/03/09.
//

import Foundation


enum QRResultResponse : Decodable {
    case success(QRResult)
    case failure(ErrorData)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = .success(try container.decode(QRResult.self))
        } catch {
            self = .failure(try container.decode(ErrorData.self))
        }
    }
}


// MARK: - User
struct QRResult: Codable {
    let id: Int
    let kind: String
    let type: String
    let title: String
    let startDate: String
    let endDate: String
    let usedDate: String
    let number: Int
    let price: Int
    let email: String?
    let name: String?
    let uuid: String
    let message: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case kind
        case type
        case title
        case startDate
        case endDate
        case usedDate
        case number
        case price
        case email
        case name
        case uuid
        case message
    }
}
