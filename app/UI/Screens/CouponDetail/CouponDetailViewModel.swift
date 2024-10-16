//
//  CouponDetailViewModel.swift
//  app
//
//  Created by Quang Nguyễn on 16/10/24.
//

import Foundation
import Combine

class CouponDetailViewModel: ObservableObject {
    var qrResult: String
    var couponDetail: CouponModel?
    @Published var isLoading: Bool = false
    
    @Published var isShowPopupResponse = false
    @Published var titlePopup: String = ""
    @Published var mesagePopup: String = ""
    
    public var disposeBag = Set<AnyCancellable>()

    init(qrResult: String, couponDetail: CouponModel?) {
        self.qrResult = qrResult
        self.couponDetail = couponDetail
    }

    
    public func comfirmCoupon() {
        isLoading = true
        Repository.shared.comfirmCoupon(uuid: qrResult) { [weak self] response in
            guard let self else { return }
            isLoading = false

            switch response {
            case .success(let success):
                isShowPopupResponse = true
                titlePopup = "Success"
                mesagePopup = success
            case .failure(let failure):
                isShowPopupResponse = true
                titlePopup = "Error"
                mesagePopup = failure.errorDescription ?? ""
            }
        }
    }
    
}
