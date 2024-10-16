//
//  ErrorResponse.swift
//  app
//
//  Created by Muune on 2023/03/07.
//

import Foundation
// MARK: - ErrorResponse
struct ErrorResponse: Codable {
    let error: ErrorData
}

enum AnyValue: Codable {
    case int(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        if let int = try? decoder.singleValueContainer().decode(Int.self) {
            self = .int(int)
            return
        }

        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(string)
            return
        }

        // 디코딩 가능한 타입이 없는경우 typeMismatch 에러 발생
        throw AnyValueError.typeMismatch
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .int(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        }
    }

    enum AnyValueError:Error {
        case typeMismatch
    }
}

extension AnyValue {
    var intValue: Int? {
        switch self {
        case .int(let value):
            return value
        case .string(let value):
            return Int(value)
        }
    }
    
    var stringValue: String? {
        switch self {
        case .int(let value):
            return String(value)
        case .string(let value):
            return value
        }
    }
}

enum APIError: LocalizedError {
    case invalidRequest
    case invalidResponse
    case serverError(ErrorData)
    case unexpected(Error)
    case emptyData(HTTPURLResponse?)
    case unauthorized
    
    var errorDescription: String? {
        switch self {
        case let .serverError(reason):
            return reason.BODY
        case .unauthorized:
            return "Phiên của bạn đã hết hạn!"
        case .invalidResponse,
             .invalidRequest,
             .unexpected,
             .emptyData:
            return "Oops! Đã xảy ra lỗi. Chúng tôi không thể hoàn thành yêu cầu của bạn"
        }
    }
}

// MARK: - ErrorData
struct ErrorData: Codable {
    let HTTP_STATUS_CODE: Int
    let MESSAGE: String?
    let HTTP_STATUS_MESSAGE: String?
    let STATE: String?
    let BODY: String?
}

enum ErrorCheckReturn:Int {
    case ERROR_NO = 0
    case RE_CALL = 1
    case IS_ERROR = 2
    case MOVE_MYCOURSE = 3
    case MOVE_LOGIN = 4
    case NEXT_NO = 5
}

