//
//  ScanQRViewModel.swift
//  app
//
//  Created by Quang Nguyễn on 16/10/24.
//

import Foundation
import Combine

class ScanQRViewModel: ObservableObject {
    @Published var couponDetail: CouponModel?
    @Published var isShowPopupError = false
    @Published var mesagePopup: String = ""
    @Published var isPresentedCouponDetail = false
    
    var vm = PlayViewModel()
    public var disposeBag = Set<AnyCancellable>()
    
    public func checkQRCode(qrResult: String) {
        Repository.shared.getCouponDetail(uuid: qrResult) { [weak self] response in
            guard let self else { return }
            
            switch response {
            case .success(let success):
                vm.play(fileNamed:  "qr_check", type: "mp3")
                couponDetail = success
                isPresentedCouponDetail.toggle()
            case .failure(let failure):
                vm.play(fileNamed: "qr_fail", type: "mp3")
                isShowPopupError = true
                mesagePopup = failure.errorDescription ?? ""
            }
        }
    }
    
}
