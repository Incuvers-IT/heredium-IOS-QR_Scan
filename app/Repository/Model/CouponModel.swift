//
//  Coupon.swift
//  app
//
//  Created by Quang Nguyễn on 16/10/24.
//

import Foundation

struct CouponModel: Codable {
    let uuid: String
    let couponName: String
    let couponType: String
    let discountPercent: Int
    let expirationDate: String
    let isPermanent: Bool
    let usedCount: Int
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case couponName = "coupon_name"
        case couponType = "coupon_type"
        case discountPercent = "discount_percent"
        case expirationDate = "expiration_date"
        case isPermanent = "is_permanent"
        case usedCount = "used_count"
    }
}
