//
//  HistoryCouponViewModel.swift
//  app
//
//  Created by Quang Nguyễn on 17/10/24.
//

import Combine

class HistoryCouponViewModel: ObservableObject {
    @Published var items: [CouponModel] = Constants.couponHistory
}
