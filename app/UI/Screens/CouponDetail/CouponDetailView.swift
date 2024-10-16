//
//  CouponDetailView.swift
//  app
//
//  Created by Quang Nguyễn on 16/10/24.
//

import SwiftUI
import Foundation

struct CouponDetailView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @ObservedObject var viewModel: CouponDetailViewModel
    
    @State private var isPresentedCouponComfirm = false

    var body: some View {
        ZStack {
            VStack {
                Text("Coupon Detail")
                    .font(Font.custom(Constants.fontBold, size: 32))
                    .foregroundColor(Color.black_11)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 8)
                
                // Discount Name
                HStack {
                    Text("Coupon Name:")
                        .font(Font.custom(Constants.fontBold, size: 20))
                        .foregroundColor(Color.black_11)
                    
                    Text(viewModel.couponDetail?.couponName ?? "")
                        .font(Font.custom(Constants.fontMedium, size: 18))
                        .foregroundColor(Color.black_11)

                    Spacer()
                }
                .padding(.bottom, 4)
                
                // Discount Type
                HStack {
                    Text("Coupon Type:")
                        .font(Font.custom(Constants.fontBold, size: 20))
                        .foregroundColor(Color.black_11)
                    
                    Text(viewModel.couponDetail?.couponType ?? "")
                        .font(Font.custom(Constants.fontMedium, size: 18))
                        .foregroundColor(Color.black_11)

                    Spacer()
                }
                .padding(.bottom, 4)
                
                // Discount Discount
                HStack {
                    Text("Discount:")
                        .font(Font.custom(Constants.fontBold, size: 20))
                        .foregroundColor(Color.black_11)
                    
                    Text("\(viewModel.couponDetail?.discountPercent ?? 0)%")
                        .font(Font.custom(Constants.fontMedium, size: 18))
                        .foregroundColor(Color.black_11)

                    Spacer()
                }
                .padding(.bottom, 4)
                
                // Discount Discount
                HStack {
                    Text("Expiration date:")
                        .font(Font.custom(Constants.fontBold, size: 20))
                        .foregroundColor(Color.black_11)
                    
                    Text(viewModel.couponDetail?.expirationDate ?? "")
                        .font(Font.custom(Constants.fontMedium, size: 18))
                        .foregroundColor(Color.black_11)

                    Spacer()
                }
                .padding(.bottom, 4)
                
                Spacer()
                
                HStack {
                    
                    Button(action: {
                        self.mode.wrappedValue.dismiss()
                    }){
                        Text("이전")
                            .font(Font.custom(Constants.fontBold, size: 14))
                            .foregroundColor(Color("primary_1"))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .frame(height: 44)
                            .border(Color("primary_1"))
                    }
                    
                    Button(action: {
                        viewModel.comfirmCoupon()
                    }){
                        Text("COMFIRM")
                            .font(Font.custom(Constants.fontBold, size: 14))
                            .foregroundColor(Color("white"))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .frame(height: 44)
                            .background(Color("primary_1"))
                    }
                }
                
            }
            .edgesIgnoringSafeArea(.all)
            .padding([.leading, .trailing], 28)
            .padding([.top, .bottom], 14)
            
            .alert(isPresented: $viewModel.isShowPopupResponse) {
                Alert(
                    title: Text(viewModel.titlePopup),
                    message: Text(viewModel.mesagePopup),
                    dismissButton: .default(Text("Cancel"), action: {
                        viewModel.isShowPopupResponse = false
                        mode.wrappedValue.dismiss()
                    })
                )
            }
            
            if viewModel.isLoading{
                LoadingScreenView().edgesIgnoringSafeArea(.all)
            }
        }
    }
}

struct CouponDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CouponDetailView(viewModel: .init(
            qrResult: "",
            couponDetail: .init(
                uuid: "",
                couponName: "",
                couponType: "",
                discountPercent: 0,
                expirationDate: "",
                isPermanent: false,
                usedCount: 0
            )
        ))
    }
}
