//
//  Constants.swift
//  app
//
//  Created by Muune on 2022/12/13.
//

import Foundation
import SwiftUI

struct Constants {
    static let isDebug = false
    static let isDev = false
    
    static let fontBold = "KoPubWorldDotumPB"
    static let fontLight = "KoPubWorldDotumPL"
    static let fontMedium = "KoPubWorldDotumPM"
    
    static let TAG = "Heredium_APP"
    
    //api
    static let BASE_DEV_URL = "https://spadecompany.net"
    static let BASE_REAL_URL = "https://heredium.art"
    static let API_VERSION = "v1"
    static let API_TOKEN = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwicm9sZSI6IkFETUlOIiwiZXhwIjo0Nzk2NjM2NDAwfQ.WFdj_KiulReJ87vZmovx38zPsr_p-r6qQfqx-1IHy9Q"

    static let TEST_URL = "https://muune87.github.io/webview/"
    static let HEREDIUM_URL_DEV = "https://spadecompany.net/app"
    static let HEREDIUM_URL = "https://heredium.art/app"
    static let HEREDIUM_TICKETING = "https://heredium.art/ticketing"
    static let HEREDIUM_DOCENT = "https://heredium.art/docent"
    static let HEREDIUM_MY = "https://heredium.art/mypage/purchase/all"
    
    static let BASE_COUPON_DEV_URL = "https://heredium-api.sotatek.works/api"
    
    static var couponHistory: [CouponModel] {
        get { UserDefaults.standard.object([CouponModel].self, with: "coupon-hisory") ?? [] }
        set { UserDefaults.standard.set(object: newValue, forKey: "coupon-hisory") }
    }
    
}

